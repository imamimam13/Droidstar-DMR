/*
	Copyright (C) 2019-2021 Doug McLain

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
import "."

Item {
	id: logTab
	property alias logText: logTxt
    // Background
    Rectangle {
        anchors.fill: parent
        color: Theme.backgroundColor

        Image {
            source: Theme.backgroundPattern
            anchors.fill: parent
            fillMode: Image.Tile
            opacity: 0.3
        }
    }

	Button {
		id: clearLogButton
		x: 10
		y: 5
		width: 100
		height: 30
		text: qsTr("Clear")
        background: Rectangle {
            color: clearLogButton.down ? Theme.accentColor : Theme.primaryColor
            radius: Theme.cornerRadius
        }
        contentItem: Text {
            text: clearLogButton.text
            font: clearLogButton.font
            color: Theme.backgroundColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
		onClicked: {
			logTxt.clear();
		}
	}
	Rectangle{
		id: logTextBox
		x: 20
		y: 40
		width: parent.width - 40
		height: parent.height - 40
		color: Theme.secondaryBackgroundColor
        radius: Theme.cornerRadius
        border.color: Theme.borderColor
        border.width: 1

		Flickable{
			id: logflick
			anchors.fill: parent
            anchors.margins: 10
			contentWidth: parent.width
			contentHeight: logTxt.y +
						   logTxt.height
			flickableDirection: Flickable.VerticalFlick
			clip: true
			ScrollBar.vertical: ScrollBar {}
			TextArea {
				id: logTxt
				width: logTextBox.width
				readOnly: true
				wrapMode: TextArea.WordWrap
				text: qsTr("")
                color: Theme.textColor
                background: null // Transparent background for TextArea
			}
		}
	}
}
