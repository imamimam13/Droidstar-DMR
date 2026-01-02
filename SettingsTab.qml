/*
	Original Copyright (C) 2019-2021 Doug McLain
   	Modification Copyright (C) 2024 Rohith Namboothiri

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
	id: settingsTab
    
    // Background
    Rectangle { 
        anchors.fill: parent
        color: "#000000" // Black background for Settings
        z: -1
        Image { 
            source: "background_pattern.png"
            anchors.fill: parent
            fillMode: Image.Tile
            opacity: 0.1 // Subtle pattern
        } 
    }

    // Property Aliases (MUST PRESERVE)
	property alias callsignEdit: csedit
	property alias dmridEdit: dmridedit
	property alias comboEssid: comboessid
	property alias bmpwEdit: bmpwedit
	property alias tgifpwEdit: tgifpwedit
	property alias latEdit: latedit
	property alias lonEdit: lonedit
	property alias locEdit: locedit
	property alias descEdit: descedit
	property alias urlEdit: urledit
	property alias swidEdit: swidedit
	property alias pkgidEdit: pkgidedit
	property alias dmroptsEdit: dmroptsedit
	property alias m173200: m17_3200
	property alias m171600: m17_1600
	property alias mycallEdit: mycalledit
	property alias urcallEdit: urcalledit
	property alias rptr1Edit: rptr1edit
	property alias rptr2Edit: rptr2edit
	property alias usrtxtEdit: usrtxtedit
	property alias txtimerEdit: txtimeredit
	property alias toggleTX: toggletx
	property alias xrf2ref: xrf2Ref
	property alias ipv6: ipV6
	property alias comboVocoder: _comboVocoder
	property alias comboModem: _comboModem
	property alias comboPlayback: _comboPlayback
	property alias comboCapture: _comboCapture
	property alias modemRXFreqEdit: _modemRXFreqEdit
	property alias modemTXFreqEdit: _modemTXFreqEdit
	property alias modemRXOffsetEdit: _modemRXOffsetEdit
	property alias modemTXOffsetEdit: _modemTXOffsetEdit
	property alias modemRXDCOffsetEdit: _modemRXDCOffsetEdit
	property alias modemTXDCOffsetEdit: _modemTXDCOffsetEdit
	property alias modemRXLevelEdit: _modemRXLevelEdit
	property alias modemTXLevelEdit: _modemTXLevelEdit
	property alias modemRFLevelEdit: _modemRFLevelEdit
	property alias modemTXDelayEdit: _modemTXDelayEdit
	property alias modemCWIdTXLevelEdit: _modemCWIdTXLevelEdit
	property alias modemDStarTXLevelEdit: _modemDStarTXLevelEdit
	property alias modemDMRTXLevelEdit: _modemDMRTXLevelEdit
	property alias modemYSFTXLevelEdit: _modemYSFTXLevelEdit
	property alias modemP25TXLevelEdit: _modemP25TXLevelEdit
	property alias modemNXDNTXLevelEdit: _modemNXDNTXLevelEdit
	property alias modemBaudEdit: _modemBaudEdit
    property alias mmdvmBox: _mmdvmBox
    property alias debugBox: _debugBox
    property alias ambestatus: _ambestatus
    property alias mmdvmstatus: _mmdvmstatus

    // Components for Styling
    component SettingSectionHeader : Text {
        color: "#ff9933"
        font.pixelSize: 14
        font.bold: true
        font.capitalization: Font.AllUppercase
        leftPadding: 15
        bottomPadding: 5
        topPadding: 20
    }

    component SettingRow : Rectangle {
        width: parent.width
        height: 50
        color: "#1a1a1a"
        border.color: "#333333"
        border.width: 0 
        
        property alias label: labelText.text
        property alias control: controlContainer.children
        
        Text {
            id: labelText
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: 16
        }
        
        Item {
            id: controlContainer
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            width: parent.width * 0.6
            // Children (Inputs/Combos) go here
        }
        
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            height: 1
            color: "#333333"
        }
    }

    component SettingInput : TextField {
        anchors.fill: parent
        color: "#ff9933"
        font.pixelSize: 16
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        background: Item {} // Transparent
        
        placeholderTextColor: "#666666"
        selectByMouse: true
    }

    component SettingCombo : ComboBox {
        anchors.fill: parent
        anchors.margins: 5
        font.pixelSize: 14
        
        contentItem: Text {
            text: parent.displayText
            font: parent.font
            color: "#ff9933"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            color: "transparent"
        }
        
        popup: Popup {
            y: parent.height
            width: parent.width
            implicitHeight: contentItem.implicitHeight
            padding: 1
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: parent.delegateModel
                currentIndex: parent.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }
            background: Rectangle {
                color: "#1a1a1a"
                border.color: "#ff9933"
                radius: 5
            }
        }
    }


	Flickable {
		id: flickable
		anchors.fill: parent
		contentWidth: parent.width
        contentHeight: contentCol.height + 50
		flickableDirection: Flickable.VerticalFlick
		clip: true
		ScrollBar.vertical: ScrollBar {}

        Column {
            id: contentCol
            width: parent.width
            spacing: 0

            // --- AUDIO & CONNECTION ---
            SettingSectionHeader { text: qsTr("Connection & Audio") }
            
            SettingRow { label: qsTr("Vocoder")
                SettingCombo { id: _comboVocoder; parent: controlContainer } 
            }
            SettingRow { label: qsTr("Modem")
                SettingCombo { id: _comboModem; parent: controlContainer }
            }
            SettingRow { label: qsTr("Playback")
                SettingCombo { id: _comboPlayback; parent: controlContainer }
            }
            SettingRow { label: qsTr("Capture")
                SettingCombo { id: _comboCapture; parent: controlContainer }
            }
            SettingRow { label: qsTr("Vocoder URL")
                SettingInput { id: _vocoderURLEdit; parent: controlContainer }
            }
             Rectangle { width: parent.width; height: 50; color: "#1a1a1a"
                 Button {
                    id: vocoderButton
                    anchors.centerIn: parent
                    text: qsTr("Download Vocoder")
                    palette.button: "#ff9933"; palette.buttonText: "#ffffff"
                    onClicked: {
                        droidstar.download_file(_vocoderURLEdit.text, true);
                        updateDialog.open();
                    }
                }
             }

            // --- IDENTITY ---
            SettingSectionHeader { text: qsTr("Identity") }
            
            SettingRow { label: qsTr("Callsign")
                SettingInput { 
                    id: csedit; parent: controlContainer
                    font.capitalization: Font.AllUppercase
                }
            }
            SettingRow { label: qsTr("DMRID")
                SettingInput { 
                    id: dmridedit; parent: controlContainer
                    inputMethodHints: Qt.ImhPreferNumbers
                }
            }
            SettingRow { label: qsTr("ESSID")
                SettingCombo { 
                    id: comboessid; parent: controlContainer 
                    function build_model(){
                        var ids = ["None"];
                        for(var i = 0; i < 100; ++i){ ids[i+1] = i.toString().padStart(2, "0"); }
                        comboessid.model = ids;
                        comboessid.currentIndex = comboessid.find(droidstar.get_essid());
                    }
                    Component.onCompleted: build_model();
                }
            }
            SettingRow { label: qsTr("BM Pass")
                SettingInput { id: bmpwedit; parent: controlContainer; echoMode: TextInput.Password }
            }
            SettingRow { label: qsTr("TGIF Pass")
                SettingInput { id: tgifpwedit; parent: controlContainer; echoMode: TextInput.Password }
            }

            // --- LOCATION & INFO ---
            SettingSectionHeader { text: qsTr("Location & Info") }
            
            SettingRow { label: qsTr("Latitude")
                SettingInput { id: latedit; parent: controlContainer }
            }
            SettingRow { label: qsTr("Longitude")
                SettingInput { id: lonedit; parent: controlContainer }
            }
            SettingRow { label: qsTr("Location")
                SettingInput { id: locedit; parent: controlContainer }
            }
            SettingRow { label: qsTr("Description")
                SettingInput { id: descedit; parent: controlContainer }
            }
            SettingRow { label: qsTr("URL")
                SettingInput { id: urledit; parent: controlContainer }
            }
            SettingRow { label: qsTr("SoftwareID")
                SettingInput { id: swidedit; parent: controlContainer }
            }
             SettingRow { label: qsTr("PackageID")
                SettingInput { id: pkgidedit; parent: controlContainer }
            }
             SettingRow { label: qsTr("DMR+ Opts")
                SettingInput { id: dmroptsedit; parent: controlContainer }
            }


            // --- ROUTING ---
            SettingSectionHeader { text: qsTr("Call Routing") }
            
            SettingRow { label: qsTr("MYCALL")
                SettingInput { id: mycalledit; parent: controlContainer; font.capitalization: Font.AllUppercase
                    onEditingFinished: droidstar.set_mycall(mycalledit.text.toUpperCase())
                }
            }
            SettingRow { label: qsTr("URCALL")
                SettingInput { id: urcalledit; parent: controlContainer; font.capitalization: Font.AllUppercase
                    onEditingFinished: droidstar.set_urcall(urcalledit.text.toUpperCase())
                }
            }
            SettingRow { label: qsTr("RPTR1")
                SettingInput { id: rptr1edit; parent: controlContainer; font.capitalization: Font.AllUppercase
                    onEditingFinished: droidstar.set_rptr1(rptr1edit.text.toUpperCase())
                }
            }
            SettingRow { label: qsTr("RPTR2")
                SettingInput { id: rptr2edit; parent: controlContainer; font.capitalization: Font.AllUppercase
                    onEditingFinished: droidstar.set_rptr2(rptr2edit.text.toUpperCase())
                }
            }
            SettingRow { label: qsTr("USRTXT")
                SettingInput { id: usrtxtedit; parent: controlContainer
                    onEditingFinished: droidstar.set_usrtxt(usrtxtedit.text)
                }
            }

            // --- SETTINGS & ACTIONS ---
            SettingSectionHeader { text: qsTr("Settings & Actions") }
            
            SettingRow { label: qsTr("TX Timeout")
                SettingInput { id: txtimeredit; parent: controlContainer }
            }
            
            // M17 Rate
            Rectangle { 
                width: parent.width; height: 50; color: "#1a1a1a";
                Text { text: "M17 Rate"; color: "white"; x: 15; anchors.verticalCenter: parent.verticalCenter }
                Row {
                    anchors.right: parent.right; anchors.rightMargin: 15; anchors.verticalCenter: parent.verticalCenter
                    spacing: 10
                    ButtonGroup { id: m17rateGroup; onClicked: button.text == "Full" ? droidstar.m17_rate_changed(true) : droidstar.m17_rate_changed(false) }
                    RadioButton { id: m17_3200; text: "Full"; ButtonGroup.group: m17rateGroup; checked: true; palette.buttonText: "white" }
                    RadioButton { id: m17_1600; text: "Data"; ButtonGroup.group: m17rateGroup; palette.buttonText: "white" }
                }
            }
            
            // Buttons
             Rectangle { width: parent.width; height: 60; color: "#1a1a1a"
                 Row {
                     anchors.centerIn: parent
                     spacing: 20
                     Button { id: updatehostsButton; text: "Update Hosts"; palette.button: "#ff9933"; palette.buttonText: "#ffffff"
                        onClicked: { droidstar.update_host_files(); updateDialog.open() }
                     }
                      Button { id: updatedmridsButton; text: "Update IDs"; palette.button: "#ff9933"; palette.buttonText: "#ffffff"
                        onClicked: { droidstar.update_dmr_ids(); updateDialog.open() }
                     }
                 }
             }

             // Toggles
            SettingRow { label: qsTr("TX Toggle Mode") 
                 Switch { id: toggletx; parent: controlContainer; anchors.right: parent.right; palette.button: "#ff9933"
                    onClicked: droidstar.set_toggletx(toggletx.checked)
                 }
            }
            SettingRow { label: qsTr("REF for XRF") 
                 Switch { id: xrf2Ref; parent: controlContainer; anchors.right: parent.right; palette.button: "#ff9933" }
            }
             SettingRow { label: qsTr("IPv6") 
                 Switch { id: ipV6; parent: controlContainer; anchors.right: parent.right; palette.button: "#ff9933" }
            }
             SettingRow { label: qsTr("Direct MMDVM") 
                 Switch { id: _mmdvmBox; parent: controlContainer; anchors.right: parent.right; palette.button: "#ff9933" }
            }
             SettingRow { label: qsTr("Debug Log") 
                 Switch { id: _debugBox; parent: controlContainer; anchors.right: parent.right; palette.button: "#ff9933" }
            }


            // --- MODEM CONFIG (Advanced) ---
            SettingSectionHeader { text: qsTr("Modem Configuration") }
            
            // Frequencies
            SettingRow { label: "RX Freq" 
                SettingInput { id: _modemRXFreqEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
            SettingRow { label: "TX Freq" 
                SettingInput { id: _modemTXFreqEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
            
            // Offsets
             SettingRow { label: "RX Offset" 
                SettingInput { id: _modemRXOffsetEdit; parent: controlContainer; }
            }
             SettingRow { label: "TX Offset" 
                SettingInput { id: _modemTXOffsetEdit; parent: controlContainer; }
            }
            SettingRow { label: "RX DC Offset" 
                SettingInput { id: _modemRXDCOffsetEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "TX DC Offset" 
                SettingInput { id: _modemTXDCOffsetEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
            
            // Levels
             SettingRow { label: "RX Level" 
                SettingInput { id: _modemRXLevelEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "TX Level" 
                SettingInput { id: _modemTXLevelEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "RF Level" 
                SettingInput { id: _modemRFLevelEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "TX Delay" 
                SettingInput { id: _modemTXDelayEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "CWID Level" 
                SettingInput { id: _modemCWIdTXLevelEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "D-Star Level" 
                SettingInput { id: _modemDStarTXLevelEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "DMR Level" 
                SettingInput { id: _modemDMRTXLevelEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "YSF Level" 
                SettingInput { id: _modemYSFTXLevelEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "P25 Level" 
                SettingInput { id: _modemP25TXLevelEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "NXDN Level" 
                SettingInput { id: _modemNXDNTXLevelEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
             SettingRow { label: "Baud" 
                SettingInput { id: _modemBaudEdit; parent: controlContainer; inputMethodHints: Qt.ImhPreferNumbers }
            }
            
            // Status (Hidden but kept for props)
             // These are usually displayed in text fields or labels, let's keep them as read-only rows for debugging
             SettingRow { label: "AMBE Status"
                 Text { id: _ambestatus; text: "Unknown"; color: "grey"; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; parent: controlContainer }
             }
             SettingRow { label: "MMDVM Status"
                 Text { id: _mmdvmstatus; text: "Unknown"; color: "grey"; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; parent: controlContainer }
             }

        } // End Column
	} // End Flickable
}
