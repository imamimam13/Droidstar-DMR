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

Item {
	id: logTab
    Rectangle { anchors.fill: parent; color: "#0d0d0d"; z: -1; Image { source: "background_pattern.png"; anchors.fill: parent; fillMode: Image.Tile; opacity: 0.2 } }
	property alias logText: logTxt
	Button { palette.button: "#ff9933"; palette.buttonText: "#ffffff";
		id: clearLogButton
		x: 10
		y: 5
		width: 100
		height: 30
		text: qsTr("Clear")
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
		color: "#0d0d0d"
		Flickable{
			id: logflick
			anchors.fill: parent
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
			}
		}
	}
}
