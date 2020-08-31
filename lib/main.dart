import 'package:flutter/material.dart';
import 'speech_recognition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice dial',
      home: SpeechScreen(),
    );
  }
}
