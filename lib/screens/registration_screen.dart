import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "RegistrationScreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    String email;
    String password;
    bool showSpinner = false;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Text(
                "REGISTER",
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 75,
                fontFamily: 'DOS',
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              style: TextStyle(
                  fontFamily: 'DOS',
                color: Colors.green,
              ),
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: "Enter your e-mail"
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              style: TextStyle(
                  fontFamily: 'DOS',
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: "Enter your Password"
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              color: Colors.blueAccent,
              content: "Register",
              onPressedFun: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email.trim(), password: password);
                  if(newUser!=null) {

                    Navigator.pushNamed(context, ChatScreen.id);
                    setState(() {
                      showSpinner = false;
                    });
                  }
                } on Exception catch (e) {
                  print(e);
                }
            },)
          ],
        ),
      ),
    );
  }
}
