import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voice_dial/screens/screens.dart';
import 'package:voice_dial/size_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice-Dial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: displayWidth(context),
          height: displayHeight(context),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'Logo_1.png',
                height: displayHeight(context) * 0.6,
                width: displayWidth(context) * 0.6,
              ),
              Text(
                "Voice Dial",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Open Sans",
                  fontSize: displayHeight(context) * 0.05,
                ),
              )
            ],
          )),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  static List<Widget> _widgetOptions = <Widget>[
    ContactPage(),
    SpeechScreen(),
    CallHistory()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 1) {
// Right Swipe
            _onItemTapped(0);
          } else if (details.delta.dx < -1) {
//Left Swipe
            _onItemTapped(2);
          }
        },
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Voice Dial'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 15.0,
        selectedFontSize: 10.0,
        unselectedFontSize: 8.0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Contacts'),
            icon: Icon(Icons.contact_phone_rounded),
          ),
          BottomNavigationBarItem(
            title: Text('Voice dial'),
            icon: Image.asset('icons8-voice-recognition-48.png'),
          ),
          BottomNavigationBarItem(
            title: Text('Call logs'),
            icon: Icon(
              Icons.history_rounded,
            ),
          )
        ],
      ),
    );
  }
}
