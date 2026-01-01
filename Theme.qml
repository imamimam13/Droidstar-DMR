pragma Singleton
import QtQuick

QtObject {
    property color backgroundColor: "#000000" // Black
    property color secondaryBackgroundColor: "#1a1a1a" // Dark Gray
    property color primaryColor: "#ff9933" // Orange
    property color accentColor: "#ffcc80" // Lighter Orange
    property color textColor: "#ffffff"
    property color secondaryTextColor: "#aaaaaa"
    property color borderColor: "#333333"
    
    property string fontFamily: "Roboto"
    property int fontSizeSmall: 12
    property int fontSizeMedium: 14
    property int fontSizeLarge: 18
    property int fontSizeExtraLarge: 24

    property int cornerRadius: 8
    property int padding: 10
}
