/*
    Copyright (C) 2019-2021 Doug McLain
    Modified Copyright (C) 2024 Rohith Namboothiri

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/


import QtQuick
import QtQuick.Controls
import org.dudetronics.droidstar


Item {
    id: mainTab
    width: 400
    height: 600

    Rectangle {
        id: bgRect
        anchors.fill: parent
        color: "#0d0d0d"
        z: -1
        Image {
            source: "background_pattern.png"
            anchors.fill: parent
            fillMode: Image.Tile
            opacity: 0.2
        }
    }
    


    //property int rows: USE_FLITE ? 20 : 18
    //property bool tts: USE_FLITE


property int rows: {
        if(USE_FLITE){
            rows = 20;
        }
        else{
            rows = 18;
        }
    }
    property bool tts: {
        if(USE_FLITE){
            tts = true;
        }
        else{
            tts = false;
        }
    }

property string firstRowSerialNumber: "N/A"
property string firstRowCallsign: "N/A"
property string firstRowHandle: "N/A"
property string firstRowCountry: "N/A"
property string secondRowSerialNumber: "N/A"
property string secondRowCallsign: "N/A"
property string secondRowHandle: "N/A"
property string secondRowCountry: "N/A"

function updateFirstRowData(serialNumber, callsign, handle, country) {
    firstRowSerialNumber = serialNumber;
    firstRowCallsign = callsign;
    firstRowHandle = handle;
    firstRowCountry = country;
}


function updateSecondRowData(serialNumber, callsign, handle, country) {
    secondRowSerialNumber = serialNumber;
    secondRowCallsign = callsign;
    secondRowHandle = handle;
    secondRowCountry = country;
}


Connections {
    target: qsoTab  // Assuming qsoTab is an instance of QsoTab somewhere higher in the hierarchy
    onFirstRowDataChanged: updateFirstRowData(serialNumber, callsign, handle, country)
    onSecondRowDataChanged: updateSecondRowData(serialNumber, callsign, handle, country)
}

    // Define the ListModel
    ListModel {
        id: recentTgidsModel
    }

    function updateRecentTgids(newTgid) {
        droidstar.addRecentTGID(newTgid);
        updateRecentTgidsModel();
    }

    function updateRecentTgidsModel() {
        recentTgidsModel.clear();
        var tgids = droidstar.loadRecentTGIDs();
        for (var i = 0; i < tgids.length; i++) {
            recentTgidsModel.append({"modelData": tgids[i]});
        }
    }


function clearRecentTgids() {
        recentTgidsModel.clear();
        droidstar.clearRecentTGIDs(); // Call the C++ function to clear persistent storage
    }

    Connections {
        target: droidstar
        onRecentTgidsUpdated: updateRecentTgidsModel()
    }

    Component.onCompleted: updateRecentTgidsModel()


// Function to update the full name with country
function updateFullNameText() {
    if (vuidUpdater.fetchedFirstName && vuidUpdater.fetchedCountry) {
        firstNameText1.text = vuidUpdater.fetchedFirstName + " (" + vuidUpdater.fetchedCountry + ")";
    } else if (vuidUpdater.fetchedFirstName) {
        firstNameText1.text = vuidUpdater.fetchedFirstName;
    } else {
        firstNameText1.text = "";
    }
}


    Timer {
        id: data2CheckTimer
        interval: 500 // 500m seconds
        repeat: false // Run once when started
        onTriggered: {
            if (_data2.text === "") {
                console.log("Data2 has been empty for 500s, clearing first name display");
                firstNameText1.text = ""; // Clear the displayed name
            }
        }
    }


    onWidthChanged: {
        if (_comboMode.currentText === "DMR") {
            _comboMode.width = (mainTab.width / 5) - 5;
            _connectbutton.width = (mainTab.width * 2 / 5) - 5;
            _connectbutton.x = (mainTab.width * 3 / 5);
        } else {
            _comboMode.width = (mainTab.width / 2) - 5;
            _connectbutton.width = (mainTab.width / 2) - 5;
            _connectbutton.x = mainTab.width / 2;
        }
    }

    Keys.onPressed: {
        console.log("Key pressed: " + event.key);
    }

    property alias element3: _element3
    property alias label1: _label1
    property alias label2: _label2
    property alias label3: _label3
    property alias label4: _label4
    property alias label5: _label5
    property alias label6: _label6
    //property alias ambestatus: _ambestatus
    //property alias mmdvmstatus: _mmdvmstatus
    property alias netstatus: _netstatus
    property alias levelMeter: _levelMeter
    property alias uitimer: _uitimer
    property alias comboMode: _comboMode
    property alias comboHost: _comboHost
    property alias dtmflabel: _dtmflabel
    property alias editIAXDTMF: _editIAXDTMF
    property alias dtmfsendbutton: _dtmfsendbutton
    property alias comboModule: _comboModule
    property alias comboSlot: _comboSlot
    property alias comboCC: _comboCC
    property alias dmrtgidEdit: _dmrtgidEdit
    property alias comboM17CAN: _comboM17CAN
    property alias privateBox: _privateBox
    property alias connectbutton: _connectbutton
    property alias sliderMicGain: _slidermicGain
    property alias data1: _data1
    property alias data2: _data2
    property alias data3: _data3
    property alias data4: _data4
    property alias data5: _data5
    property alias data6: _data6
    property alias txtimer: _txtimer
    property alias buttonTX: _buttonTX
    property alias btntxt: _btntxt
    property alias swtxBox: _swtxBox
    property alias swrxBox: _swrxBox
    property alias agcBox: _agcBox
    property alias recentTgLabel: recentTgLabel
    property alias recentTgidsComboBox: recentTgidsComboBox
    property alias lastHeard: lastHeard
    property alias firstRowData: firstRowData
    property alias secondRowData: secondRowData
   
// UI Components
Text {
    id: recentTgLabel
    text: qsTr("Recent TG")
    color: "#ffffff"
    font.pixelSize: parent.height / 40
    x: 10
    y: (parent.height / rows + 1) * 3 // Adjust y position to fit layout
    width: parent.width / 4 // Adjust width to fit next to the ComboBox
    height: parent.height / rows
    verticalAlignment: Text.AlignVCenter
    visible: true
    

}

ComboBox {
    id: recentTgidsComboBox
    x: recentTgLabel.x + recentTgLabel.width + 5 // Position next to recentTgLabel
    y: recentTgLabel.y // Align vertically with recentTgLabel
    width: (parent.width * 3 / 4) - 15 - 10 // Adjust width to fit in the remaining space
    height: parent.height / rows
    font.pixelSize: parent.height / 35
    visible: true
    model: recentTgidsModel
    textRole: "modelData"

contentItem: Text {
        text: recentTgidsComboBox.currentText
        color: "#ffffff"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    // Override the popup for the ComboBox
    popup: Popup {
        width: parent.width
        //height: 50 // Adjust height as needed

        Column {
            width: parent.width
            spacing: 5

            Repeater {
                model: recentTgidsModel
                delegate: Item {
                    width: parent.width
                    height: 30
                    Text {
                        text: modelData
                        width: parent.width
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        color: "#ffffff" // Set the text color to white
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                _dmrtgidEdit.text = modelData; // Set the selected TGID to the TextField
                                recentTgidsComboBox.currentIndex = index; // Update ComboBox to show selected item
                                recentTgidsComboBox.popup.close(); // Close the popup after selection
                                console.log("droidstar.tgid_text_changed called from onClicked with TGID:", modelData); // Log event
                                droidstar.tgid_text_changed(dmrtgidEdit.text);  // Notify backend of TGID change
  
                            }
                        }
                    }
                }
            }

            // Clear button inside the ComboBox popup
            Button { palette.button: "#ff9933"; palette.buttonText: "#ffffff";
                text: qsTr("Clear")
                width: parent.width
                onClicked: clearRecentTgids()
            }
        }
    }

    onActivated: {
        _dmrtgidEdit.text = currentText; // Set the selected TGID to the TextField
        //console.log("droidstar.tgid_text_changed called from onActivated with TGID:", currentText); // Log event
//droidstar.tgid_text_changed(currentText);  // Notify backend of TGID change
  
    }
}



    Timer {
        id: _uitimer
        interval: 20
        running: true
        repeat: true
        property int cnt: 0
        property int rxcnt: 0
        property int last_rxcnt: 0
        onTriggered: update_level()

        function update_level() {
            if (cnt >= 20) {
                if (rxcnt === last_rxcnt) {
                    droidstar.set_output_level(0);
                    rxcnt = 0;
                    // console.log("TIMEOUT");
                } else {
                    last_rxcnt = rxcnt;
                }

                cnt = 0;
            } else {
                ++cnt;
            }

            var l = (parent.width - 20) * droidstar.get_output_level() / 32767.0;
            if (l > _levelMeter.width) {
                _levelMeter.width = l;
            } else {
                if (_levelMeter.width > 0) _levelMeter.width -= 8;
                else _levelMeter.width = 0;
            }
        }
    }
    ComboBox {
        id: _comboMode
        property bool loaded: false
        x: 10
        y: 5
        width: (parent.width * 0.25)
        height: (parent.height / rows) - 15
        font.pixelSize: parent.height / 45
        currentIndex: -1
        displayText: currentIndex === -1 ? "Mode..." : currentText
        model: ["M17", "YSF", "FCS", "DMR", "P25", "NXDN", "REF", "XRF", "DCS", "IAX"]
        
        background: Rectangle {
            color: "#000000"
            border.color: "#ff9933"
            border.width: 1
            radius: 5
        }

        contentItem: Text {
            text: _comboMode.displayText
            font: _comboMode.font
            leftPadding: 5
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }
        
        popup: Popup {
            y: parent.height
            width: parent.width
            implicitHeight: Math.min(contentItem.implicitHeight, 300) // Increase max height
            padding: 1
            parent: Overlay.overlay
            transformOrigin: Item.Top
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: _comboMode.delegateModel
                currentIndex: _comboMode.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }
            background: Rectangle {
                color: "#1a1a1a"
                border.color: "#ff9933"
                radius: 5
            }
        }
        
        onCurrentTextChanged: {
            if (_comboMode.loaded) {
                droidstar.process_mode_change(_comboMode.currentText);
            }
        }
    }
    ComboBox {
        id: _comboSlot
        x: _comboMode.x + _comboMode.width + 10
        y: 5
        width: (parent.width * 0.2)
        height: (parent.height / rows) - 15
        font.pixelSize: parent.height / 45
        model: ["S1", "S2"]
        currentIndex: 1
        
        background: Rectangle {
            color: "#000000"
            border.color: "#ff9933"
            border.width: 1
            radius: 5
        }
        
        contentItem: Text {
            text: _comboSlot.displayText
            font: _comboSlot.font
            leftPadding: 5
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }
        onCurrentTextChanged: {
            droidstar.set_slot(_comboSlot.currentIndex);
        }
        visible: true
    }
    ComboBox {
        id: _comboCC
        x: _comboSlot.x + _comboSlot.width + 10
        y: 5
        width: (parent.width * 0.2)
        height: (parent.height / rows) - 5
        font.pixelSize: parent.height / 45
        model: [
            "CC0", "CC1", "CC2", "CC3", "CC4", "CC5", "CC6", "CC7",
            "CC8", "CC9", "CC10", "CC11", "CC12", "CC13", "CC14", "CC15"
        ]
        currentIndex: 1
        
        background: Rectangle {
            color: "#000000"
            border.color: "#ff9933"
            border.width: 1
            radius: 5
        }
        
        contentItem: Text {
            text: _comboCC.displayText
            font: _comboCC.font
            leftPadding: 5
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }
        onCurrentTextChanged: {
            droidstar.set_cc(_comboCC.currentIndex);
        }
        visible: true // Enable visibility
    }
    Button {
        id: _connectbutton
        x: parent.width - width - 10
        y: 5
        width: parent.width * 0.25
        height: (parent.height / rows) - 5
        text: qsTr("Connect")
        font.pixelSize: parent.height / 45
        
        background: Rectangle {
            color: "#ff9933"
            radius: 5
        }
        contentItem: Text {
            text: _connectbutton.text
            font: _connectbutton.font
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        onClicked: {
            // settingsTab.callsignEdit.text = settingsTab.callsignEdit.text.toUpperCase();
            droidstar.set_callsign(settingsTab.callsignEdit.text.toUpperCase());
            // droidstar.set_host(comboHost.currentText);
            droidstar.set_module(comboModule.currentText);
            droidstar.set_protocol(comboMode.currentText);
            droidstar.set_dmrtgid(dmrtgidEdit.text);
            droidstar.set_dmrid(settingsTab.dmridEdit.text);
            droidstar.set_essid(settingsTab.comboEssid.currentText);
            droidstar.set_bm_password(settingsTab.bmpwEdit.text);
            droidstar.set_tgif_password(settingsTab.tgifpwEdit.text);
            droidstar.set_latitude(settingsTab.latEdit.text);
            droidstar.set_longitude(settingsTab.lonEdit.text);
            droidstar.set_location(settingsTab.locEdit.text);
            droidstar.set_description(settingsTab.descEdit.text);
            droidstar.set_url(settingsTab.urlEdit.text);
            droidstar.set_swid(settingsTab.swidEdit.text);
            droidstar.set_pkgid(settingsTab.pkgidEdit.text);
            droidstar.set_dmr_options(settingsTab.dmroptsEdit.text);
            droidstar.set_dmr_pc(mainTab.privateBox.checked);
            droidstar.set_txtimeout(settingsTab.txtimerEdit.text);
            // droidstar.set_toggletx(toggleTX.checked);
            droidstar.set_xrf2ref(settingsTab.xrf2ref.checked);
            droidstar.set_ipv6(settingsTab.ipv6.checked);
            droidstar.set_vocoder(settingsTab.comboVocoder.currentText);
            droidstar.set_modem(settingsTab.comboModem.currentText);
            droidstar.set_playback(settingsTab.comboPlayback.currentText);
            droidstar.set_capture(settingsTab.comboCapture.currentText);

            droidstar.set_modemRxFreq(settingsTab.modemRXFreqEdit.text);
            droidstar.set_modemTxFreq(settingsTab.modemTXFreqEdit.text);
            droidstar.set_modemRxOffset(settingsTab.modemRXOffsetEdit.text);
            droidstar.set_modemTxOffset(settingsTab.modemTXOffsetEdit.text);
            droidstar.set_modemRxDCOffset(settingsTab.modemRXDCOffsetEdit.text);
            droidstar.set_modemTxDCOffset(settingsTab.modemTXDCOffsetEdit.text);
            droidstar.set_modemRxLevel(settingsTab.modemRXLevelEdit.text);
            droidstar.set_modemTxLevel(settingsTab.modemRXLevelEdit.text);
            droidstar.set_modemRFLevel(settingsTab.modemRFLevelEdit.text);
            droidstar.set_modemTxDelay(settingsTab.modemTXDelayEdit.text);
            droidstar.set_modemCWIdTxLevel(settingsTab.modemCWIdTXLevelEdit.text);
            droidstar.set_modemDstarTxLevel(settingsTab.modemDStarTXLevelEdit.text);
            droidstar.set_modemDMRTxLevel(settingsTab.modemDMRTXLevelEdit.text);
            droidstar.set_modemYSFTxLevel(settingsTab.modemYSFTXLevelEdit.text);
            droidstar.set_modemP25TxLevel(settingsTab.modemYSFTXLevelEdit.text);
            droidstar.set_modemNXDNTxLevel(settingsTab.modemNXDNTXLevelEdit.text);
            droidstar.set_modemBaud(settingsTab.modemBaudEdit.text);
            // droidstar.set_mmdvm_direct(settingsTab.mmdvmBox.checked)
            droidstar.process_connect();
        }
    }
    ComboBox {
        id: _comboHost
        x: 10
        y: (parent.height / rows + 1) * 1
        width: parent.width * 0.6
        height: (parent.height / rows) - 15
        font.pixelSize: parent.height / 45
        currentIndex: -1
        displayText: currentIndex === -1 ? "Host..." : currentText
        
        background: Rectangle {
            color: "#1a1a1a" // Darker input style
            border.color: "#ff9933"
            border.width: 1
            radius: 5
        }
        
        contentItem: Text {
            text: _comboHost.displayText
            font: _comboHost.font
            leftPadding: 5
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }
        
        popup: Popup {
            y: parent.height
            width: parent.width
            implicitHeight: Math.min(contentItem.implicitHeight, 300) // Increase max height
            padding: 1
            parent: Overlay.overlay
            transformOrigin: Item.Top
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: _comboHost.delegateModel
                currentIndex: _comboHost.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }
            background: Rectangle {
                color: "#1a1a1a"
                border.color: "#ff9933"
                radius: 5
            }
        }
        
        onCurrentTextChanged: {
            if (settingsTab.mmdvmBox.checked) {
                droidstar.set_dst(_comboHost.currentText);
            }
            if (!droidstar.get_modelchange()) {
                droidstar.process_host_change(_comboHost.currentText);
            }
        }
    }
    ComboBox {
        id: _comboModule
        x: (parent.width * 3) / 4
        y: (parent.height / rows + 1) * 1
        width: (parent.width / 4) - 5
        height: (parent.height / rows) - 15
        font.pixelSize: parent.height / 35
        currentIndex: -1
        displayText: currentIndex === -1 ? "Mod..." : currentText
        model: [
            " ",
            "A",
            "B",
            "C",
            "D",
            "E",
            "F",
            "G",
            "H",
            "I",
            "J",
            "K",
            "L",
            "M",
            "N",
            "O",
            "P",
            "Q",
            "R",
            "S",
            "T",
            "U",
            "V",
            "W",
            "X",
            "Y",
            "Z"
        ]
        contentItem: Text {
            text: _comboModule.displayText
            font: _comboModule.font
            leftPadding: 10
            verticalAlignment: Text.AlignVCenter
            color: _comboModule.enabled ? "white" : "darkgrey"
        }
        onCurrentTextChanged: {
            if (_comboMode.loaded) {
                droidstar.set_module(_comboModule.currentText);
            }
        }
    }
    Switch {
        id: _privateBox
        x: _comboHost.x + _comboHost.width + 10
        y: (parent.height / rows + 1) * 1
        text: qsTr("Private")
        palette.button: "#ff9933"
        height: (parent.height / rows) - 5
        
        indicator: Rectangle {
            implicitWidth: 36
            implicitHeight: 20
            x: _privateBox.leftPadding
            y: parent.height / 2 - height / 2
            radius: 10
            color: _privateBox.checked ? "#ff9933" : "#333333"
            border.color: "#ff9933"

            Rectangle {
                x: _privateBox.checked ? parent.width - width - 2 : 2
                width: 16
                height: 16
                radius: 8
                y: 2
                color: "#ffffff"
                Behavior on x {
                    NumberAnimation { duration: 100 }
                }
            }
        }
        
        contentItem: Text {
            text: _privateBox.text
            font.pixelSize: parent.height / 50
            opacity: enabled ? 1.0 : 0.3
            color: "white"
            verticalAlignment: Text.AlignVCenter
            leftPadding: _privateBox.indicator.width + _privateBox.spacing
        }
        
        onClicked: {
            droidstar.set_dmr_pc(privateBox.checked);
            // console.log("screen size ", parent.width, " x ", parent.height);
        }
        visible: true // Enable visibility
    }
    Text {
        id: _dtmflabel
        x: 5
        y: (parent.height / rows + 1) * 3
        width: parent.width / 5
        height: parent.height / rows
        text: qsTr("DTMF")
        color: "#ffffff"
        font.pixelSize: parent.height / 30
        verticalAlignment: Text.AlignVCenter
        visible: false
    }
    TextField {
        id: _editIAXDTMF
        x: parent.width / 4
        y: (parent.height / rows + 1) * 3
        width: (parent.width * 3 / 8) - 4
        height: parent.height / rows
        font.pixelSize: parent.height / 35
        // inputMethodHints: "ImhPreferNumbers"
        visible: false
    }
    Button { palette.button: "#ff9933"; palette.buttonText: "#ffffff";
        id: _dtmfsendbutton
        x: (parent.width * 5 / 8)
        y: (parent.height / rows + 1) * 3
        width: (parent.width * 3 / 8) - 5
        height: parent.height / rows
        text: qsTr("Send")
        font.pixelSize: parent.height / 30
        onClicked: {
            droidstar.dtmf_send_clicked(editIAXDTMF.text);
        }
        visible: false
    }
    Text {
        id: _bigTgidDisplay
        x: 10
        y: (parent.height / rows + 1) * 2
        text: "TGID " + (_dmrtgidEdit.text ? _dmrtgidEdit.text : "----")
        color: "#ff9933"
        font.pixelSize: parent.height / 25
        font.bold: true
        verticalAlignment: Text.AlignVCenter
    }
    
    // Hidden original element
    Text {
        id: _element3
        visible: false
    }
    TextField {
        visible: false
        id: _dmrtgidEdit
        x: parent.width / 5
        y: (parent.height / rows + 1) * 2
        width: parent.width / 5
        height: parent.height / rows
        font.pixelSize: parent.height / 35
        selectByMouse: true
        inputMethodHints: "ImhPreferNumbers"
        text: qsTr("")
        onEditingFinished: {
            droidstar.tgid_text_changed(dmrtgidEdit.text);
            console.log("droidstar.tgid_text_changed called from onEditingFinished with TGID:", dmrtgidEdit.text); // Log event
            updateRecentTgids(dmrtgidEdit.text);
            //tgidsModel = droidstar.loadRecentTGIDs();
            updateRecentTgidsModel(); // Refresh the ListModel correctly
        }
    }

    ComboBox {
        visible: false
        id: _comboM17CAN
        x: parent.width / 5
        y: (parent.height / rows + 1) * 2
        width: parent.width / 5
        height: parent.height / rows
        font.pixelSize: parent.height / 35
        currentIndex: 0
        model: ["0", "1", "2", "3", "4", "5", "6", "7"]
        contentItem: Text {
            text: _comboM17CAN.displayText
            font: _comboM17CAN.font
            leftPadding: 10
            verticalAlignment: Text.AlignVCenter
            color: _comboM17CAN.enabled ? "white" : "darkgrey"
        }
        onCurrentTextChanged: {
            droidstar.set_modemM17CAN(_comboM17CAN.currentText);
        }
    }
    Switch {
        id: _swtxBox
        x: (parent.width * 2 / 5) + 5
        y: (parent.height / rows + 1) * 2
        text: qsTr("SWTX")
        palette.button: "#ff9933"
        indicator: Rectangle {
            implicitWidth: 40
            implicitHeight: 20
            radius: 13
            color: _swtxBox.checked ? "#ff9933" : "#333333"
            border.color: "#ff9933"
            Rectangle {
                x: _swtxBox.checked ? parent.width - width - 2 : 2
                y: 2
                width: 16
                height: 16
                radius: 8
                color: "#ffffff"
            }
        }
        contentItem: Text {
            text: _swtxBox.text
            color: "white"
            leftPadding: _swtxBox.indicator.width + _swtxBox.spacing
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: droidstar.set_swtx(_swtxBox.checked)
    }
    Switch {
        id: _swrxBox
        x: _swtxBox.x + _swtxBox.width + 10 // Stack right
        y: (parent.height / rows + 1) * 2
        text: qsTr("SWRX")
        palette.button: "#ff9933"
        indicator: Rectangle {
            implicitWidth: 40
            implicitHeight: 20
            radius: 13
            color: _swrxBox.checked ? "#ff9933" : "#333333"
            border.color: "#ff9933"
            Rectangle {
                x: _swrxBox.checked ? parent.width - width - 2 : 2
                y: 2
                width: 16
                height: 16
                radius: 8
                color: "#ffffff"
            }
        }
        contentItem: Text {
            text: _swrxBox.text
            color: "white"
            leftPadding: _swrxBox.indicator.width + _swrxBox.spacing
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: droidstar.set_swrx(_swrxBox.checked)
    }

    Switch {
        id: _agcBox
        x: _swrxBox.x + _swrxBox.width + 10
        y: (parent.height / rows + 1) * 2
        text: qsTr("AGC")
        palette.button: "#ff9933"
        indicator: Rectangle {
            implicitWidth: 40
            implicitHeight: 20
            radius: 13
            color: _agcBox.checked ? "#ff9933" : "#333333"
            border.color: "#ff9933"
            Rectangle {
                x: _agcBox.checked ? parent.width - width - 2 : 2
                y: 2
                width: 16
                height: 16
                radius: 8
                color: "#ffffff"
            }
        }
        contentItem: Text {
            text: _agcBox.text
            color: "white"
            leftPadding: _agcBox.indicator.width + _agcBox.spacing
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: droidstar.set_agc(_agcBox.checked)
    }

    Text {
        id: micgain_label
        x: 10
        y: (parent.height / rows + 1) * 4
        width: parent.width / 4
        height: parent.height / rows
        text: qsTr("Mic")
        color: "#ffffff"
        font.pixelSize: parent.height / 40
        verticalAlignment: Text.AlignVCenter
    }
    Slider {
        property double v
        visible: true
        id: _slidermicGain
        x: (parent.width / 4) + 10
        y: (parent.height / rows + 1) * 4
        width: (parent.width * 3 / 4) - 20
        height: parent.height / rows
        value: 0.1
        
        background: Rectangle {
            x: _slidermicGain.leftPadding
            y: _slidermicGain.topPadding + _slidermicGain.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: _slidermicGain.availableWidth
            height: 4
            radius: 2
            color: "#333333"

            Rectangle {
                width: _slidermicGain.visualPosition * parent.width
                height: parent.height
                color: "#ff9933"
                radius: 2
            }
        }

        handle: Rectangle {
            x: _slidermicGain.leftPadding + _slidermicGain.visualPosition * (_slidermicGain.availableWidth - width)
            y: _slidermicGain.topPadding + _slidermicGain.availableHeight / 2 - height / 2
            implicitWidth: 26
            implicitHeight: 26
            radius: 13
            color: "#ff9933"
            border.color: "#ffffff"
        }
        
        onValueChanged: {
            v = value * 100
            droidstar.set_input_volume(value)
            micgain_label.text = "Mic " + v.toFixed(1)
        }
    }



    Text {
        id: _label1
        x: 10
        y: (parent.height / rows + 1) * 5
        width: parent.width / 3
        height: parent.height / rows
        text: qsTr("MYCALL")
        color: "#ffffff"
        font.pixelSize: parent.height / 40
    }




// Static label for "Handle"
Text {
        id: fnameLabel
        x: 10
        y: (parent.height / rows + 1) * 6 // Position below the mic gain slider
        width: parent.width / 3
        height: parent.height / rows 
        
        text: qsTr("Handle")
        color: "#ffffff"
        font.pixelSize: parent.height / 40
    }


TextField {
        id: firstNameText1
        x: parent.width / 3
        y: (parent.height / rows + 1) * 6
        width: (parent.width * 2) / 3 - 20
        height: parent.height / rows
        
        readOnly: true
        color: "#ffffff"
        text: vuidUpdater.fetchedFirstName + (vuidUpdater.fetchedCountry !== "" ? " (" + vuidUpdater.fetchedCountry + ")" : "")
        // wrapMode: Text.WordWrap // TextField handles scrolling usually
        font.pixelSize: 14
        
        background: Rectangle {
            color: "#1a1a1a"
            border.color: "#ff9933"
            border.width: 1
            radius: 5
        }

        onTextChanged:  { console.log("Text changed to:", text);
    }
}




    Text {
        id: _label2
        x: 10
        y: (parent.height / rows + 1) * 7.2
        width: parent.width / 3
        height: parent.height / rows
        text: qsTr("URCALL")
        color: "#ffffff"
        font.pixelSize: parent.height / 40
    }

    Text {
        id: _label3
        x: 10
        y: (parent.height / rows + 1) * 8.2
        width: parent.width / 3
        height: parent.height / rows
        text: qsTr("RPTR1")
        color: "#ffffff"
        font.pixelSize: parent.height / 40
    }

    Text {
        id: _label4
        x: 10
        y: (parent.height / rows + 1) * 9.2
        width: parent.width / 3
        height: parent.height / rows
        text: qsTr("RPTR2")
        color: "#ffffff"
        font.pixelSize: parent.height / 40
    }

    Text {
        id: _label5
        x: 10
        y: (parent.height / rows + 1) * 10.2
        width: parent.width / 3
        height: parent.height / rows
        text: qsTr("StrmID")
        color: "#ffffff"
        font.pixelSize: parent.height / 40
    }

    Text {
        id: _label6
        x: 10
        y: (parent.height / rows + 1) * 11.2
        width: parent.width / 3
        height: parent.height / rows
        text: qsTr("Text")
        color: "#ffffff"
        font.pixelSize: parent.height / 40
    }
    Text {
        id: _label7
        x: 10
        y: (parent.height / rows + 1) * 12.2
        width: parent.width / 3
        height: parent.height / rows
        text: qsTr("")
        color: "#ffffff"
        font.pixelSize: parent.height / 40
    }
TextField {
    id: _data1
    x: parent.width / 3
    y: (parent.height / rows + 1) * 5
    width: (parent.width * 2) / 3 - 20 // Adjust for padding
    height: parent.height / rows
    text: qsTr("")
    readOnly: true
    color: "white"
    font.pixelSize: 14
    
    background: Rectangle {
        color: "#1a1a1a"
        border.color: "#ff9933"
        border.width: 1
        radius: 5
    }
}

Text {
    id: _data2
    x: parent.width / 3
    y: (parent.height / rows + 1) * 7.2
    width: (parent.width * 2) / 3
    height: parent.height / rows
    text: qsTr("")
    color: "#ffffff"
    font.pixelSize: parent.height / 40

    Timer {
        id: stabilityTimer
        interval: 200  // 200 milliseconds to verify text stability
        repeat: false
        onTriggered: {
            if (_data2.text !== "") {
                console.log("Data2 stable and non-empty for 200ms:", _data2.text);
                data2CheckTimer.stop(); // Stop the main timer as data is stable and non-empty
                let dataInt = parseInt(_data2.text);
                if (!isNaN(dataInt)) {
                    vuidUpdater.fetchFirstNameFromAPI(dataInt);
                    emitDataUpdated();
                } else {
                    console.log("Invalid data input, not a number:", _data2.text);
                }
            } else {
                console.log("Data2 became empty before 100ms elapsed.");
            }
        }
    }

        onTextChanged: {
        console.log("Data2 changed, new value:", text);

        if (text === "") {
            data2CheckTimer.start(); // Start the timer if data2 is empty
            return;  // Exit after starting the timer for empty input
        }

        console.log("Restarting stabilityTimer due to change in Data2");
        // Reset and start the stability timer whenever text changes
        stabilityTimer.restart();
    }
}










Connections {
    target: vuidUpdater
    function onFetchedFirstNameChanged(name) {
        console.log("Fetched first name updated to:", name);
        updateFullNameText(); // Function to update the full text
    }

    function onFetchedCountryChanged(country) {
        console.log("Fetched country updated to:", country);
        updateFullNameText(); // Function to update the full text
    }
}





/*
// Function to update the full name with country
function updateFullNameText() {
    firstNameText1.text = vuidUpdater.fetchedFirstName + " (" + vuidUpdater.fetchedCountry + ")";
} */




/*
Connections {
        target: vuidUpdater
        function onFetchedFirstNameChanged(name) {
            console.log("Fetched first name updated to:", name);
            firstNameText1.text = name; // Explicitly set the text
        }
    }
*/

    TextField {
        id: _data3
        x: parent.width / 3
        y: (parent.height / rows + 1) * 8.2
        width: (parent.width * 2) / 3 - 20
        height: parent.height / rows
        text: qsTr("")
        readOnly: true
        color: "white"
        font.pixelSize: 14
        background: Rectangle {
            color: "#1a1a1a"
            border.color: "#ff9933"
            border.width: 1
            radius: 5
        }
    }

    TextField {
        id: _data4
        x: parent.width / 3
        y: (parent.height / rows + 1) * 9.2
        width: (parent.width * 2) / 3 - 20
        height: parent.height / rows
        text: qsTr("")
        readOnly: true
        color: "white"
        font.pixelSize: 14
        background: Rectangle {
            color: "#1a1a1a"
            border.color: "#ff9933"
            border.width: 1
            radius: 5
        }
    }

    TextField {
        id: _data5
        x: parent.width / 3
        y: (parent.height / rows + 1) * 10.2
        width: (parent.width * 2) / 3 - 20
        height: parent.height / rows
        text: qsTr("")
        readOnly: true
        color: "white"
        font.pixelSize: 14
        background: Rectangle {
            color: "#1a1a1a"
            border.color: "#ff9933"
            border.width: 1
            radius: 5
        }
    }

    TextField {
        id: _data6
        x: parent.width / 3
        y: (parent.height / rows + 1) * 11.2
        width: (parent.width * 2) / 3 - 20
        height: parent.height / rows
        text: qsTr("")
        readOnly: true
        color: "white"
        font.pixelSize: 14
        background: Rectangle {
            color: "#1a1a1a"
            border.color: "#ff9933"
            border.width: 1
            radius: 5
        }
    }
    TextField {
        id: _data7
        x: parent.width / 3
        y: (parent.height / rows + 1) * 12.2
        width: (parent.width * 2) / 3 - 20
        height: parent.height / rows
        text: qsTr("")
        readOnly: true
        color: "white"
        font.pixelSize: 14
        background: Rectangle {
            color: "#1a1a1a"
            border.color: "#ff9933"
            border.width: 1
            radius: 5
        }
    }

   /* Text {
        id: _ambestatus
        x: 10
        y: _data7.y + _data7.height - 40
        width: parent.width - 30
        height: parent.height / rows
        text: qsTr("No AMBE hardware connected")
        color: "#ffffff"
        font.pixelSize: parent.height / 45
    }
    Text {
        id: _mmdvmstatus
        x: 10
        y: _ambestatus.y + _ambestatus.height
        width: parent.width - 40
        height: parent.height / rows
        text: qsTr("No MMDVM connected")
        color: "#ffffff"
        font.pixelSize: parent.height / 35
    }*/

   // Text elements to display the last heard data
Text {
    id: lastHeard
    x: 10
    y: _data7.y + _data7.height - 80
    width: parent.width - 40
    height: parent.height / rows
    text: qsTr("Last Heard")
    color: "#ffffff"
    font.pixelSize: parent.height / 35
}

// Text element to display first row data
Text {
    id: firstRowData
    x: 10
    y: lastHeard.y + lastHeard.height
    width: parent.width - 40
    height: parent.height / rows
    text: (firstRowSerialNumber !== "N/A" ? firstRowSerialNumber + ". " : "") +
          (firstRowCallsign !== "N/A" ? firstRowCallsign : "") +
          (firstRowHandle !== "N/A" && firstRowCallsign !== "N/A" ? " - " : "") + 
          (firstRowHandle !== "N/A" ? firstRowHandle : "") + 
          (firstRowCountry !== "N/A" && (firstRowCallsign !== "N/A" || firstRowHandle !== "N/A") ? " - " : "") +
          (firstRowCountry !== "N/A" ? firstRowCountry : "")
    color: "#ffffff"
    font.pixelSize: parent.height / 45
    wrapMode: Text.WordWrap
}

// Text element to display second row data
Text {
    id: secondRowData
    x: 10
    y: firstRowData.y + firstRowData.height
    width: parent.width - 40
    height: parent.height / rows
    text: (secondRowSerialNumber !== "N/A" ? secondRowSerialNumber + ". " : "") +
          (secondRowCallsign !== "N/A" ? secondRowCallsign : "") +
          (secondRowHandle !== "N/A" && secondRowCallsign !== "N/A" ? " - " : "") + 
          (secondRowHandle !== "N/A" ? secondRowHandle : "") + 
          (secondRowCountry !== "N/A" && (secondRowCallsign !== "N/A" || secondRowHandle !== "N/A") ? " - " : "") +
          (secondRowCountry !== "N/A" ? secondRowCountry : "")
    color: "#ffffff"
    font.pixelSize: parent.height / 45
    wrapMode: Text.WordWrap
}


   /* Text {
        id: _netstatus
        x: 10
        y: (parent.height / rows + 1) * 15
        width: parent.width - 20
        height: parent.height / rows
        text: qsTr("Not Connected to network")
        color: "#ffffff"
        font.pixelSize: parent.height / 35
    }*/
    Rectangle {
        x: 10
        y: (parent.height / rows + 1.1) * 14.2
        width: parent.width - 20
        height: parent.height / 30
        color: "#ffffff"
        border.color: "#ffffff"
        border.width: 1
        radius: 5
    }
    Text {
        x: 10
        y: (parent.height / rows + 1.1) * 13.5
        width: parent.width - 20
        text: qsTr("Audio Visualizer")
        color: "darkgrey"
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
    }
    Rectangle {
        id: _levelMeter
        x: 10
        y: (parent.height / rows + 1.1) * 14.2
        width: 0
        height: parent.height / 30
        color: "#ff9933"
        radius: 2
        opacity: 0.8
    }
    ButtonGroup {
        id: ttsvoicegroup
        onClicked: {
            droidstar.tts_changed(button.text);
        }
    }
    CheckBox {
        id: mic
        visible: tts ? true : false
        x: 5
        y: (parent.height / rows + 1) * 17
        height: 25
        spacing: 1
        text: qsTr("Mic")
        checked: true
        ButtonGroup.group: ttsvoicegroup
    }
    CheckBox {
        id: tts1
        visible: tts ? true : false
        x: parent.width / 4
        y: (parent.height / rows + 1) * 17
        height: 25
        spacing: 1
        text: qsTr("TTS1")
        ButtonGroup.group: ttsvoicegroup
    }
    CheckBox {
        id: tts2
        visible: tts ? true : false
        x: parent.width * 2 / 4
        y: (parent.height / rows + 1) * 17
        height: 25
        spacing: 1
        text: qsTr("TTS2")
        checked: true
        ButtonGroup.group: ttsvoicegroup
    }
    CheckBox {
        id: tts3
        visible: tts ? true : false
        x: parent.width * 3 / 4
        y: (parent.height / rows + 1) * 17
        height: 25
        spacing: 1
        text: qsTr("TTS3")
        ButtonGroup.group: ttsvoicegroup
    }
    TextField {
        id: _ttstxtedit
        visible: tts ? true : false
        x: 5
        y: (parent.height / rows + 1) * 18
        width: parent.width - 10
        height: parent.height / rows
        font.pixelSize: parent.height / 35
        selectByMouse: true
        inputMethodHints: "ImhPreferNumbers"
        text: qsTr("")
        onEditingFinished: {
            droidstar.tts_text_changed(_ttstxtedit.text);
        }
    }




property string dmrID: _data2.text
property string tgid: _data3.text  // Assuming _data3 contains the TGID

signal dataUpdated(var receivedDmrID, var receivedTGID)

Timer {
    id: updateTimer
    interval: 500  // Delay in ms, adjust as needed for your case
    repeat: false
    onTriggered: {
        if (dmrID && tgid) {
            console.log("Emitting dmrID:", dmrID, "and TGID:", tgid);
            dataUpdated(dmrID, parseInt(tgid));  // Emit both dmrID and tgid as integers
        } else {
            console.log("DMR ID or TGID is missing, not emitting");
        }
    }
}

function emitDataUpdated() {
    updateTimer.restart();  
}

onDmrIDChanged: {
    console.log("DMR ID changed, restarting update timer.");
    emitDataUpdated();  
}



    Button { palette.button: "#ff9933"; palette.buttonText: "#ffffff";
    Timer {
        id: _txtimer
        repeat: true
        onTriggered: {
            ++buttonTX.cnt;
            btntxt.text = "TX: " + buttonTX.cnt;
            if (buttonTX.cnt >= parseInt(settingsTab.txtimerEdit.text)) {
                buttonTX.tx = false;
                droidstar.click_tx(buttonTX.tx);
                _txtimer.running = false;
                _btntxt.text = "TX";
            }
        }
    }

    property bool tx: false
    property int cnt: 0
    visible: true
    enabled: false
    id: _buttonTX
    background: Rectangle {
        color: _buttonTX.tx ? "#800000" : "steelblue"
        radius: 10

       
        Column {
            anchors.centerIn: parent
            spacing: 5
            width: parent.width

            Text {
                id: _btntxt
                font.pointSize: 20 
                text: qsTr("TX")
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: _netstatus
                text: qsTr("Not Connected to network")
                color: "#ffffff"
                font.pixelSize: 16  // Adjust font size for better readability
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
    x: 10
    y: (parent.height / rows + 1) * (tts ? 17 : 15)
    width: parent.width - 20
    height: parent.height - y - 10
    font.pointSize: 24

    onClicked: {
        if (settingsTab.toggleTX.checked) {
            tx = !tx;
            droidstar.click_tx(tx);
            if (tx) {
                cnt = 0;
                _txtimer.running = true;
                _btntxt.color = "white";
            } else {
                _txtimer.running = false;
                btntxt.color = "black";
                _btntxt.text = "TX";
            }
        }
    }
    onPressed: {
        if (!settingsTab.toggleTX.checked) {
            tx = true;
            droidstar.press_tx();
        }
    }
    onReleased: {
        if (!settingsTab.toggleTX.checked) {
            tx = false;
            droidstar.release_tx();
        }
    }
    onCanceled: {
        if (!settingsTab.toggleTX.checked) {
            tx = false;
            droidstar.release_tx();
        }
    }
}
}
