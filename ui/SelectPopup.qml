import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "qrc:/ui" as UI

// Background
Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "#80000000"
    visible: false
    z: 999999

    // When an option is selected
    signal selected(string nameSelected)
    
    // Close animation
    PropertyAnimation { 
        id: closeAnimation
        target: root; 
        property: "opacity"; 
        to: 0 
        duration: 400
        easing.type: Easing.InOutQuad
        onStopped: root.visible = false;
    }
    

    property string title: ""
    property var contents: []

    // Real popup
    Rectangle {
        id: realPopup
        color: "white"
        width: title.length * 40
        height: 20 + 75 + (root.contents.length * 45)
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: (parent.height - 64 - this.height) / 2
        anchors.leftMargin: (parent.width - this.width) / 2

        // Padding
        Rectangle {
            id: paddingPopup
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 20

            // Title
            Text {
                id: popupTitle
                width: (parent.width * 0.25) / 2 - 40
                height: 75
                wrapMode: Text.WordWrap
                font.weight: Font.Thin
                font.pixelSize: 50
                text: root.title
            }

            // Showing button list 
            Component {
                id: buttonListShow
                UI.Button {
                    width: (parent.width * 0.75) - 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 15
                    flat: true

                    onClicked: function(){
                        root.selected(selectionId)
                        closeAnimation.running = true
                    }

                    contentItem: Text {
                        Image {
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            source: icon
                            sourceSize.width: 24
                            sourceSize.height: 24
                        }
                        id: browserName
                        verticalAlignment: Text.AlignVCenter
                        text: "         " + title
                        font.pixelSize: 18

                    }

                }
            }
        }
        
    }

    // Popup shadow
    DropShadow {
        anchors.fill: realPopup
        horizontalOffset: 2
        verticalOffset: 2
        radius: 40.0
        samples: 17
        color: "#80000000"
        source: realPopup
    }

    // List
    ListModel {
        id: buttonsList
        Component.onCompleted: function(){
            root.contents.forEach(function(elem){
                buttonsList.append({"title": elem[0], "selectionId": elem[1], "icon": elem[2]})
                
            })
        }
        
    }

    // Manager
    ListView {
        anchors.top: realPopup.top
        anchors.topMargin: 95
        anchors.left: realPopup.left
        anchors.leftMargin: -50
        height: (root.contents.length * 45) - 30
        width: title.length * 40 - 20
        id: buttonListView
        model: buttonsList
        delegate: buttonListShow
        z: 10
    }
}
