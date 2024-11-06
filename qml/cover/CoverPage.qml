/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../lib/API.js" as Logic


CoverBackground {
    onStatusChanged: {
        switch (status ){
        case PageStatus.Activating:
            console.log("PageStatus.Activating")
            //timer.triggered()
            break;
        case PageStatus.Inactive:
            //timer.triggered()
            console.log("PageStatus.Inactive")
            break;
        }
    }

    Image {
        id: bg
        source: "../images/tooter-cover.svg"
        horizontalAlignment: Image.AlignLeft
        verticalAlignment: Image.AlignBottom
        fillMode: Image.PreserveAspectFit
        anchors {
            bottom : parent.bottom
            left: parent.left
            right: parent.right
            top: parent.top
        }
    }

    Timer {
        id: timer
        interval: 60*1000
        triggeredOnStart: true
        repeat: true
        onTriggered: checkNotifications();
    }

    Image {
        id: iconNot
        source: "image://theme/icon-s-alarm?" + Theme.highlightColor
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: Theme.paddingLarge
            topMargin: Theme.paddingLarge
        }
    }

    Label {
        id: notificationsLbl
        text: " "
        color: Theme.highlightColor
        anchors {
            left: iconNot.right
            leftMargin: Theme.paddingMedium
            verticalCenter: iconNot.verticalCenter
        }
    }

    Label {
        text: "Tooter β"
        color: Theme.secondaryColor
        anchors {
            right: parent.right
            rightMargin: Theme.paddingLarge
            verticalCenter: iconNot.verticalCenter
        }
    }

    signal activateapp(string person, string notice)
    CoverActionList {
        id: coverAction
        /*CoverAction {
            iconSource: "image://theme/icon-cover-next"
             onTriggered: {
                 Logic.conf.notificationLastID = 0;
             }
        }*/

        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("./../pages/ConversationPage.qml"), {
                                   headerTitle: qsTr("New Toot"),
                                   type: "new"
                               })
                appWindow.activate()
            }
        }
    }
    function checkNotifications(){
        console.log("checkNotifications")
        var notificationsNum = 0
        var notificationLastID = Logic.conf.notificationLastID;
        //Logic.conf.notificationLastID = 0;
        for(var i = 0; i < Logic.modelTLnotifications.count; i++) {
            if (notificationLastID < Logic.modelTLnotifications.get(i).id) {
                notificationLastID = Logic.modelTLnotifications.get(i).id
            }

            if (Logic.conf.notificationLastID < Logic.modelTLnotifications.get(i).id) {
                notificationsNum++
                Logic.notifier(Logic.modelTLnotifications.get(i))
            }
        }
        notificationsLbl.text = notificationsNum;
        Logic.conf.notificationLastID = notificationLastID;
    }

}
