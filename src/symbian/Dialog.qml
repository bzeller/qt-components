/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Qt Labs.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

import Qt 4.7
import "." 1.0

Item {
    id: root

    property alias title: titleItem.children
    property alias content: contentItem.children
    property alias buttons: buttonItem.children
    property alias visualParent: dialog.visualParent
    property alias status: dialog.status

    signal accepted
    signal rejected

    function open() {
        dialog.open()
    }

    function accept() {
        dialog.close()
        accepted()
    }

    function reject() {
        dialog.close()
        rejected()
    }

    function close() {
        dialog.close()
    }

    visible: false

    Component.onCompleted: {
        if (!width)
            width = style.current.preferredWidth
        if (!height)
            height = style.current.preferredHeight
    }

    Popup {
        id: dialog

        function getWidth() {
            return root.width > style.current.get("maxWidth") ? style.current.get("maxWidth") : root.width
        }

        function getHeight() {
            return root.height > style.current.get("maxHeight") ? style.current.get("maxHeight") : root.height
        }

        width: getWidth()
        height: getHeight()
        state: "Hidden"
        visible: true
        anchors.centerIn: parent
        animationDuration: 800

        BorderImage {
            source: style.current.get("popupBackground")
            border { left: 20; top: 20; right: 20; bottom: 20 }
            anchors.fill: parent
        }

        Style {
            id: style
            styleClass: "Dialog"
        }

        Item {
            id: titleBar

            height: style.current.get("titleTextHeight") + 2 * style.current.get("titleMargin")
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            BorderImage {
                source: style.current.get("titleBackground")
                border { left: 40; top: 0; right: 40; bottom: 0 }
                anchors.fill: parent
            }

            Item {
                id: titleItem

                clip: true
                anchors {
                    fill: parent
                    margins: style.current.get("titleMargin")
                }
            }
        }

        Item {
            id: contentItem

            clip: true
            anchors {
                top: titleBar.bottom
                left: parent.left
                right: parent.right
                bottom: buttonItem.top
                margins: style.current.get("contentMargin")
            }
        }

        Item {
            id: buttonItem

            height: childrenRect.height
            clip: true
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                topMargin: style.current.get("buttonMargin")
            }
        }

        states: [
            State {
                name: "Visible"
                when: status == DialogStatus.Opening || status == DialogStatus.Open
                PropertyChanges { target: dialog; opacity: 1.0 }
            },
            State {
                name: "Hidden"
                when: status == DialogStatus.Closing || status == DialogStatus.Closed
                PropertyChanges { target: dialog; opacity: 0.0 }
            }
        ]

        transitions: [
            Transition {
                from: "Visible"; to: "Hidden"
                SequentialAnimation {
                    ScriptAction {script: status = DialogStatus.Closing }
                    NumberAnimation { properties: "opacity"; duration: dialog.animationDuration }
                    ScriptAction {script: status = DialogStatus.Closed }
                }
            },
            Transition {
                from: "Hidden"; to: "Visible"
                SequentialAnimation {
                    ScriptAction { script: status = DialogStatus.Opening }
                    NumberAnimation { properties: "opacity"; duration: dialog.animationDuration }
                    ScriptAction { script: status = DialogStatus.Open }
                }
            }
        ]
    }
}
