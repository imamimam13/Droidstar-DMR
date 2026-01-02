/*
    Copyright (C) 2024 Rohith Namboothiri

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs

Item {
    id: qsoTab
    // property MainTab mainTab: null
    property int dmrID: -1
    property int tgid: -1
    property string logFileName: "logs.json"
    property string savedFilePath: ""
    property int latestSerialNumber: 0
    property bool isLoading: true

    // Background
    Rectangle { 
        anchors.fill: parent
        color: "#000000" 
        z: -1
        Image { 
            source: "background_pattern.png"
            anchors.fill: parent
            fillMode: Image.Tile
            opacity: 0.1
        }
    }

    signal firstRowDataChanged(string serialNumber, string callsign, string handle, string country)
    signal secondRowDataChanged(string serialNumber, string callsign, string handle, string country)

    ListModel { id: logModel }

    function updateRowData() {
       // Keep existing signal logic if needed for MainTab updates
       if (logModel.count > 0) {
           var firstRow = logModel.get(0);
           firstRowDataChanged(firstRow.serialNumber, firstRow.callsign, firstRow.fname, firstRow.country);
       } else {
           firstRowDataChanged("N/A", "N/A", "N/A", "N/A");
       }
       if (logModel.count > 1) {
           var secondRow = logModel.get(1);
           secondRowDataChanged(secondRow.serialNumber, secondRow.callsign, secondRow.fname, secondRow.country);
       } else {
           secondRowDataChanged("N/A", "N/A", "N/A", "N/A");
       }
    }
    
    Connections {
       target: logModel
       onCountChanged: updateRowData()
    }

    Component.onCompleted: {
          if (typeof mainTab !== "undefined" && mainTab) {
              mainTab.dataUpdated.connect(onDataUpdated);
          }
          // Load dummy data or real data
          updateRowData();
          loadSettings();
    }

    function saveSettings() {
        var logData = [];
           for (var i = 0; i < logModel.count; i++) {
               logData.push(logModel.get(i));
           }
           logHandler.saveLog(logFileName, logData);
    }

    function loadSettings() {
        isLoading = true;
        var savedData = logHandler.loadLog(logFileName);
        for (var i = 0; i < savedData.length; i++) {
            savedData[i].checked = false;
            logModel.append(savedData[i]);
            latestSerialNumber = Math.max(latestSerialNumber, savedData[i].serialNumber + 1);
        }
        isLoading = false;
    }

    function clearSettings() {
        logModel.clear();
        logHandler.clearLog(logFileName);
        latestSerialNumber = 0;
    }

    function onDataUpdated(receivedDmrID, receivedTGID) {
        qsoTab.dmrID = receivedDmrID;  
        qsoTab.tgid = receivedTGID;    
        fetchData(receivedDmrID, receivedTGID);
    }
    
    function fetchData(dmrID, tgid) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://radioid.net/api/dmr/user/?id=" + dmrID, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var response = JSON.parse(xhr.responseText);
                if (response.count > 0) {
                    var result = response.results[0];
                    addEntry({
                        callsign: result.callsign,
                        dmrID: result.id,
                        tgid: tgid, 
                        country: result.country,
                        fname: result.fname,
                        currentTime: "Just Now" // Simplified
                    });
                }
            }
        };
        xhr.send();
    }

    function addEntry(data) {
        if (!data) return;
        if (data.country === "United States") data.country = "USA";
        if (data.country === "United Kingdom") data.country = "UK";

        latestSerialNumber += 1;
        logModel.insert(0, {
            serialNumber: latestSerialNumber,
            callsign: data.callsign,
            dmrID: data.dmrID,
            tgid: data.tgid,
            country: data.country,
            fname: data.fname,
            currentTime: data.currentTime,
            checked: false
        });
        saveSettings();
        if(logModel.count > 250) logModel.remove(logModel.count - 1);
    }

    // --- UI Implementation --
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header / Title
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: "transparent"
            Text {
                text: "Droidstar QSO List"
                color: "#ff9933"
                font.bold: true
                font.pixelSize: 20
                anchors.centerIn: parent
            }
             Text {
                text: "+"
                color: "#ff9933"
                font.pixelSize: 24
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                // Placeholder for add action
            }
        }
        
        // Search Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.margins: 10
            height: 40
            color: "#1a1a1a"
            radius: 10
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                Text { text: "\uf002"; font.family: "FontAwesome"; color: "#666666"; font.pixelSize: 14 }
                TextInput {
                    Layout.fillWidth: true
                    text: "Search QSOs..."
                    color: "#999999"
                    font.pixelSize: 16
                    selectByMouse: true
                }
            }
        }
        
        // List View
        ListView {
            id: qsoList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: logModel
            clip: true
            spacing: 0
            
            delegate: Rectangle {
                width: qsoList.width
                height: 70
                color: "transparent"
                
                // Avatar Placeholder
                Rectangle {
                    id: avatar
                    width: 50
                    height: 50
                    radius: 25
                    color: "#333333"
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: callsign.substring(0,2) // Initials-ish
                        color: "#999999"
                        font.bold: true
                    }
                }
                
                // Callsign & Name
                Column {
                    anchors.left: avatar.right
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4
                    
                    Text {
                        text: callsign
                        color: "#ff9933"
                        font.bold: true
                        font.pixelSize: 16
                    }
                     Text {
                        text: fname
                        color: "white"
                        font.pixelSize: 14
                    }
                     Text {
                        text: "Last Heard: " + currentTime
                        color: "white"
                        font.pixelSize: 12
                        opacity: 0.7
                    }
                }
                
                // Status Indicator
                Column {
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 5
                    
                    Text {
                        text: "Online" 
                        color: "#4CAF50" // Green
                        font.pixelSize: 12
                        anchors.right: parent.right
                    }
                     Rectangle {
                        width: 10; height: 10
                        radius: 5
                        color: "#4CAF50"
                        anchors.right: parent.right
                    }
                }
                
                // Separator
                Rectangle {
                    width: parent.width - 20
                    height: 1
                    color: "#333333"
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
