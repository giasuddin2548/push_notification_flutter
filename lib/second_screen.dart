import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  String payload;
  SecondScreen(this.payload);


  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Title ${widget.payload}'),),
    );
  }
}
