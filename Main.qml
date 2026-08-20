import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    id: root
    width: Screen.width
    height: Screen.height

    property int baseWidth: 1080
    property int baseHeight: 607
    property real scaleFactor: Math.min(width / baseWidth, height / baseHeight)
    property int sessionIndex: sessionChooser.currentIndex >= 0 ? sessionChooser.currentIndex : 0
    property int selectedUserIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0
    property bool loggingIn: false
    property string errorText: ""
    property bool userMenuOpen: false
    property bool sessionMenuOpen: false
    property string selectedUserName: ""
    property color accent: "#968763"
    property color accentText: "#d7c8b5"
    property color panel: "#32161f"

    function login() {
        if (loggingIn)
            return
        if (username.text.trim().length === 0 || password.text.length === 0) {
            errorText = "Enter your password"
            password.forceActiveFocus()
            return
        }
        loggingIn = true
        errorText = ""
        sddm.login(username.text, password.text, sessionIndex)
    }

    function chooseUser(name, index) {
        selectedUserName = name
        selectedUserIndex = index
        username.text = name
        userMenuOpen = false
        username.forceActiveFocus()
        username.selectAll()
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            loggingIn = false
            password.selectAll()
            errorText = "Login failed"
            password.forceActiveFocus()
        }
    }

    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl("assets/background.jpg")
        fillMode: Image.PreserveAspectCrop
        smooth: true
        asynchronous: true
    }

    Text {
        id: clock
        x: root.width * (772 / 1080)
        y: root.height * (104 / 607)
        width: root.width * (205 / 1080)
        height: root.height * (78 / 607)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: root.accent
        text: Qt.formatTime(new Date(), "HH:mm")
        font.family: "JetBrains Mono"
        font.pixelSize: 55 * root.scaleFactor
        font.bold: true
        renderType: Text.NativeRendering
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: clock.text = Qt.formatTime(new Date(), "HH:mm")
    }

    Text {
        id: day
        x: root.width * (782 / 1080)
        y: root.height * (206 / 607)
        width: root.width * (186 / 1080)
        height: root.height * (30 / 607)
        horizontalAlignment: Text.AlignHCenter
        color: "#8f7b63"
        text: Qt.formatDate(new Date(), "dddd d")
        font.family: "Sans"
        font.pixelSize: 18 * root.scaleFactor
        font.bold: true
    }

    // Compact, custom clickable user selector.
    Rectangle {
        id: userChooser
        x: root.width * (778 / 1080)
        y: root.height * (301 / 607)
        width: root.width * (170 / 1080)
        height: 21 * root.scaleFactor
        color: "transparent"
        border.color: root.accent
        border.width: Math.max(1, Math.round(1.15 * root.scaleFactor))
        radius: 5 * root.scaleFactor
        z: 20
        scale: userHover.containsMouse ? 1.012 : 1.0
        Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
        Behavior on border.color { ColorAnimation { duration: 140; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 140; easing.type: Easing.OutCubic } }

        Text {
            anchors.fill: parent
            anchors.leftMargin: 8 * root.scaleFactor
            anchors.rightMargin: 22 * root.scaleFactor
            text: root.selectedUserName.length ? root.selectedUserName : "Select user"
            color: root.accentText
            font.family: "Sans"
            font.pixelSize: 10.5 * root.scaleFactor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 7 * root.scaleFactor
            anchors.verticalCenter: parent.verticalCenter
            text: root.userMenuOpen ? "▲" : "▼"
            color: root.accent
            font.pixelSize: 8 * root.scaleFactor
        }

        MouseArea {
            id: userHover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.userMenuOpen = !root.userMenuOpen
                root.sessionMenuOpen = false
            }
        }

        Rectangle {
            id: userMenu
            x: 0
            y: parent.height + 5 * root.scaleFactor
            width: parent.width
            height: Math.min(userModel.count * 25 * root.scaleFactor + 8 * root.scaleFactor,
                             180 * root.scaleFactor)
            visible: root.userMenuOpen
            color: "#24151a"
            border.color: root.accent
            border.width: Math.max(1, Math.round(1.0 * root.scaleFactor))
            radius: 5 * root.scaleFactor
            clip: true
            opacity: visible ? 1 : 0
            scale: visible ? 1 : 0.96
            transformOrigin: Item.Top
            z: 50
            Behavior on opacity { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
            Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

            ListView {
                anchors.fill: parent
                anchors.margins: 4 * root.scaleFactor
                model: userModel
                interactive: contentHeight > height
                delegate: Rectangle {
                    width: ListView.view.width
                    height: 25 * root.scaleFactor
                    color: userItemMouse.containsMouse ? Qt.rgba(0.588, 0.529, 0.388, 0.16) : "transparent"
                    radius: 4 * root.scaleFactor
                    Behavior on color { ColorAnimation { duration: 100 } }

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 8 * root.scaleFactor
                        text: model.name
                        color: root.accentText
                        font.family: "Sans"
                        font.pixelSize: 10 * root.scaleFactor
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        id: userItemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.chooseUser(model.name, index)
                    }
                }
            }
        }
    }

    Rectangle {
        id: loginBox
        x: root.width * (778 / 1080)
        y: root.height * (329 / 607)
        width: root.width * (170 / 1080)
        height: 21 * root.scaleFactor
        color: "transparent"
        border.color: root.accent
        border.width: Math.max(1, Math.round(1.15 * root.scaleFactor))
        radius: 5 * root.scaleFactor
    }

    TextInput {
        id: username
        anchors.fill: loginBox
        anchors.margins: 2 * root.scaleFactor
        leftPadding: 7 * root.scaleFactor
        rightPadding: 7 * root.scaleFactor
        color: root.accentText
        selectionColor: Qt.rgba(0.588, 0.529, 0.388, 0.32)
        selectedTextColor: root.accentText
        font.family: "Sans"
        font.pixelSize: 10 * root.scaleFactor
        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignHCenter
        text: userModel.lastIndex >= 0 ? userModel.get(userModel.lastIndex).name : ""
        enabled: !root.loggingIn
        selectByMouse: true
        activeFocusOnPress: true
        onAccepted: password.forceActiveFocus()
    }

    Rectangle {
        id: passwordBox
        x: root.width * (778 / 1080)
        y: root.height * (355 / 607)
        width: root.width * (170 / 1080)
        height: 21 * root.scaleFactor
        color: "transparent"
        border.color: root.accent
        border.width: Math.max(1, Math.round(1.15 * root.scaleFactor))
        radius: 5 * root.scaleFactor
    }

    TextInput {
        id: password
        anchors.fill: passwordBox
        anchors.margins: 2 * root.scaleFactor
        leftPadding: 7 * root.scaleFactor
        rightPadding: 7 * root.scaleFactor
        color: root.accentText
        selectionColor: Qt.rgba(0.588, 0.529, 0.388, 0.32)
        selectedTextColor: root.accentText
        font.family: "Sans"
        font.pixelSize: 10 * root.scaleFactor
        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignHCenter
        echoMode: TextInput.Password
        passwordCharacter: "•"
        enabled: !root.loggingIn
        selectByMouse: true
        activeFocusOnPress: true
        onAccepted: root.login()
    }

    Rectangle {
        id: loginButton
        x: root.width * (778 / 1080)
        y: root.height * (381 / 607)
        width: root.width * (170 / 1080)
        height: 21 * root.scaleFactor
        radius: 5 * root.scaleFactor
        color: loginMouse.containsMouse ? Qt.rgba(0.588, 0.529, 0.388, 0.16) : "transparent"
        border.color: root.accent
        border.width: Math.max(1, Math.round(1.15 * root.scaleFactor))
        opacity: root.loggingIn ? 0.55 : 1
        scale: loginMouse.containsMouse && !root.loggingIn ? 1.012 : 1
        Behavior on color { ColorAnimation { duration: 140; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

        Text {
            anchors.fill: parent
            text: root.loggingIn ? "Logging in..." : "Login"
            color: root.accentText
            font.family: "Sans"
            font.pixelSize: 10.5 * root.scaleFactor
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: loginMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: root.loggingIn ? Qt.ArrowCursor : Qt.PointingHandCursor
            enabled: !root.loggingIn
            onClicked: root.login()
        }
    }

    Text {
        id: errorLabel
        x: root.width * (760 / 1080)
        y: root.height * (409 / 607)
        width: root.width * (205 / 1080)
        height: root.height * (22 / 607)
        text: root.errorText
        color: "#d59a8c"
        font.family: "Sans"
        font.pixelSize: 9.5 * root.scaleFactor
        horizontalAlignment: Text.AlignHCenter
        visible: root.errorText.length > 0
    }

    // Compact, custom clickable session selector in the bottom-left.
    Rectangle {
        id: sessionChooser
        property int currentIndex: 0
        x: root.width * (28 / 1080)
        y: root.height - height - (22 * root.scaleFactor)
        width: root.width * (150 / 1080)
        height: 22 * root.scaleFactor
        color: "transparent"
        border.color: root.accent
        border.width: Math.max(1, Math.round(1.15 * root.scaleFactor))
        radius: 5 * root.scaleFactor
        z: 20
        scale: sessionHover.containsMouse ? 1.012 : 1.0
        Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

        Text {
            anchors.fill: parent
            anchors.leftMargin: 8 * root.scaleFactor
            anchors.rightMargin: 22 * root.scaleFactor
            text: sessionModel.count > sessionChooser.currentIndex ? sessionModel.get(sessionChooser.currentIndex).name : "Session"
            color: root.accentText
            font.family: "Sans"
            font.pixelSize: 10 * root.scaleFactor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 7 * root.scaleFactor
            anchors.verticalCenter: parent.verticalCenter
            text: root.sessionMenuOpen ? "▲" : "▼"
            color: root.accent
            font.pixelSize: 8 * root.scaleFactor
        }

        MouseArea {
            id: sessionHover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.sessionMenuOpen = !root.sessionMenuOpen
                root.userMenuOpen = false
            }
        }

        Rectangle {
            id: sessionMenu
            x: 0
            y: -Math.min(sessionModel.count * 25 * root.scaleFactor + 8 * root.scaleFactor,
                         180 * root.scaleFactor) - 5 * root.scaleFactor
            width: parent.width
            height: Math.min(sessionModel.count * 25 * root.scaleFactor + 8 * root.scaleFactor,
                             180 * root.scaleFactor)
            visible: root.sessionMenuOpen
            color: "#24151a"
            border.color: root.accent
            border.width: Math.max(1, Math.round(1.0 * root.scaleFactor))
            radius: 5 * root.scaleFactor
            clip: true
            opacity: visible ? 1 : 0
            scale: visible ? 1 : 0.96
            transformOrigin: Item.Bottom
            z: 50
            Behavior on opacity { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
            Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

            ListView {
                anchors.fill: parent
                anchors.margins: 4 * root.scaleFactor
                model: sessionModel
                interactive: contentHeight > height
                delegate: Rectangle {
                    width: ListView.view.width
                    height: 25 * root.scaleFactor
                    color: sessionItemMouse.containsMouse ? Qt.rgba(0.588, 0.529, 0.388, 0.16) : "transparent"
                    radius: 4 * root.scaleFactor
                    Behavior on color { ColorAnimation { duration: 100 } }

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 8 * root.scaleFactor
                        text: model.name
                        color: root.accentText
                        font.family: "Sans"
                        font.pixelSize: 9.5 * root.scaleFactor
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        id: sessionItemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            sessionChooser.currentIndex = index
                            root.sessionMenuOpen = false
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (userModel.lastIndex >= 0 && userModel.count > userModel.lastIndex)
            root.selectedUserName = userModel.get(userModel.lastIndex).name
    }
}