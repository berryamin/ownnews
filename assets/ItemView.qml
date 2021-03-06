import bb.cascades 1.0
import com.kdab.components 1.0
import uk.co.piggz 1.0

Page {
    id: itemView
    property string title: ""
    property string body: ""
    property string link: ""
    property string author: ""
    property string pubdate: ""
    property bool unread: false
    property bool starred: false

    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                navigationPane.pop()
            }
        }
    }

    actions: [
        ActionItem {
            id: actionOpen
            title: "Open"
            onTriggered: {
                // will auto-invoke after re-arming
                console.log("open", link);
                invokeLink.query.uri = link;
            }
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///ic_world.png"
        },
        ActionItem {
            id: actionShare
            title: "Share"
            onTriggered: {
                // will auto-invoke after re-arming
                console.log("share", link);
                invokeQuery.mimeType = "text/plain"
                invokeQuery.data = itemView.title + "\n" + link;
                invokeQuery.updateQuery();
            }
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///ic_share.png"
        }
    ]

    attachedObjects:
        [
        Invocation {
            id: invokeLink
            property bool auto_trigger: false
            query {
                uri: "http://www.google.com"

                onUriChanged: {
                    invokeLink.query.updateQuery();
                }
            }

            onArmed: {
                // don't auto-trigger on initial setup
                if (auto_trigger)
                    trigger("bb.action.OPEN");
                auto_trigger = true;    // allow re-arming to auto-trigger
            }
        },
        Invocation {
               id: invokeShare
               query: InvokeQuery {
                   id:invokeQuery
                   mimeType: "text/plain"
               }
               onArmed: {
                   if (invokeQuery.data != "") {
                       trigger("bb.action.SHARE");
                   }
               }
            }
    ]

    ScrollView {
        Container {

            leftPadding: 30
            rightPadding:30
            topPadding: 15
            bottomPadding: 15

            Label {
                id: lblTitle
                multiline: true
                text: title

                textStyle {
                    base: SystemDefaults.TextStyles.TitleText
                    color: Color.Black
                }
            }

            Container {
                layout: StackLayout {
                    orientation:  LayoutOrientation.LeftToRight
                }

                Label {
                    id: lblAuthor
                    text: author

                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }

                    textStyle {
                        base: SystemDefaults.TextStyles.TitleText
                        color: Color.Black
                        fontSize: FontSize.Small
                    }
                }
                Label {
                    id: lblDate
                    text: pubdate
                    horizontalAlignment: HorizontalAlignment.Right
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }

                    textStyle {
                        base: SystemDefaults.TextStyles.TitleText
                        color: Color.Black
                        fontSize: FontSize.Small
                    }
                }
            }

            Label {
                id: lblBody
                multiline: true

                text: body

                textStyle {
                    base: SystemDefaults.TextStyles.BodyText
                    color: Color.DarkGray
                    textAlign: TextAlign.Left
                }

            }
        }
    }
}
