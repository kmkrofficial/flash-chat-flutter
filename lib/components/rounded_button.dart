import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  const RoundedButton({@required this.color, @required this.content, @required
  this.onPressedFun});
  final Color color;
  final String content;
  final Function onPressedFun;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: Colors.black,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressedFun,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            content,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'DOS',
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}