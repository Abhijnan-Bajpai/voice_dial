import 'dart:io';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import '../size_helper.dart';
import 'package:call_number/call_number.dart';
import 'package:avatar_glow/avatar_glow.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  RegExp phoneNumber = RegExp(r'[0-9][\s]*[0-9][\s]*[0-9][\s]*[0-9][\s]*[0-9][\s]*[0-9][\s]*[0-9][\s]*[0-9][\s]*[0-9][\s]*[0-9][\s]*');
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  _initCall() async {
    if (_text != null) {
      if (_text != 'Press the button and start speaking')
        await new CallNumber().callNumber(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
            child: Text(
              _text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: displayHeight(context) * 0.05,
                  fontFamily: 'Open Sans'),
            ),
          ),
        ),
        Text(
          "Dial a number verbally, by saying something like: '0123456789'\n\nLong press to cancel",
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,

          ),
          textAlign: TextAlign.center,
        ),
        AvatarGlow(
          animate: _isListening,
          glowColor: Colors.redAccent,
          endRadius: displayHeight(context) * 0.12,
          duration: Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: Duration(milliseconds: 100),
          child: RawMaterialButton(
              onLongPress: _cancel,
              onPressed: _listen,
              child: Icon(
                _isListening ? Icons.mic : Icons.call,
                size: displayHeight(context) * 0.05,
                color: _isListening ? Colors.red : Colors.white,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: _isListening ? Colors.white : Colors.green,
              padding: EdgeInsets.all(displayHeight(context) * 0.05)),
        ),
      ],
    );
  }

  void _cancel() async {
    if(_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
        _text = 'Press the button and start speaking';
      });
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            print("Recognized words:\n");
            print(val.recognizedWords);
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      // _text.replaceAll('Call', '');
      // _text.replaceAll(' ', '');
      if(phoneNumber.hasMatch(_text))
        {
          _initCall();
        }
      else {
        setState(() {
          _text = 'Press the button and start speaking';
        });
      }
    }
  }
}

// floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// floatingActionButton: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: <Widget>[
// FloatingActionButton(
// onPressed: _listen,
// child: Icon(_isListening ? Icons.mic : Icons.mic_none),
// ),
// FloatingActionButton(
// onPressed: _initCall,
// child: Icon(Icons.call),
// backgroundColor: Colors.green,
// )
// ],
// ),
// ),
