import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var timeDate = DateTime.now();
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = "ChatScreen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  String message;
  final textController = TextEditingController();

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text(
          'Group Chat',
          textAlign: TextAlign.center,
          style: TextStyle(
          color: Colors.green,
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: 'DOS'
        ),),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        fontFamily: 'DOS'
                      ),
                      controller: textController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textController.clear();
                      _firestore
                          .collection('messages')
                          .add({'text': message, 'sender': loggedInUser.email, 'timestamp': DateTime.now()});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('timestamp', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageWidgets = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          bool isMe;
          if(messageSender == loggedInUser.email) isMe = true;
          else isMe=false;

          final messageWidget = MessageBubble(
              messageText: messageText, messageSender: messageSender, isMe: isMe,);
          messageWidgets.add(messageWidget);
        }
        return Expanded(
            child: ListView(
              reverse: true,
              children: messageWidgets,
            ));
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key key,
    @required this.messageText,
    @required this.messageSender,
    @required this.isMe,
  }) : super(key: key);

  final String messageText;
  final String messageSender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            messageSender,
            style: TextStyle(
              fontFamily: 'DOS',
              fontSize: 12.0,
              color: Colors.green,
            ),
          ),
          Material(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                messageText,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 20,
                  color: isMe? Colors.white:Colors.green,
                  fontFamily: 'DOS'
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
