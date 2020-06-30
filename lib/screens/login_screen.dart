import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    String email;
    String password;
    bool showSpinner = false;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Text (
                  "LOGIN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 100,
                    fontFamily: 'DOS',
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontFamily: 'DOS',
                ),
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter your e-mail"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontFamily: 'DOS',
                ),
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "Enter your password",
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  color: Colors.lightBlueAccent,
                  content: "Log in",
                  onPressedFun: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final validation = await _auth.signInWithEmailAndPassword(
                          email: email.trim(), password: password);
                      if (validation != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }catch (e) {
                      print(e);
                    }
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
