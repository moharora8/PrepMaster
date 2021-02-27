import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/config.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'home.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:splashscreen/splashscreen.dart' as s;
import 'config/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Authentication/authenication.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PrepApp.sharedPreferences = await SharedPreferences.getInstance();
  PrepApp.auth = FirebaseAuth.instance;
  PrepApp.firestore = Firestore.instance;
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: s.SplashScreen(
        seconds: 5,
        navigateAfterSeconds: HomePage(),
        title: Text(
          'Place Prep',
          textScaleFactor: 2,
        ),
        image: new Image.asset('assets/images/students-cap.png'),
        loadingText: Text(
          "Lead the way",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        photoSize: 100.0,
        loaderColor: Colors.blue,
      ),
      theme:
          ThemeData(primaryColor: primaryColor, brightness: Brightness.light),
      // darkTheme:
      //     ThemeData(brightness: Brightness.dark, primaryColor: primaryColor),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fbm = FirebaseMessaging();
  String _message = '';
  void getMessage() {
    fbm.configure(onMessage: (Map<String, dynamic> message) async {
      print('received message');
      print("onMessage: $message");
      var tag = message['notification']['title'];
      if (tag == 'Order Received') {
        print('Tag is right');
        // go to puppy page
      } else if (tag == 'catty') {
        // go to catty page
      }
      setState(() => _message = message["notification"]["body"]);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["body"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["body"]);
    });
  }

  _registerOnFirebase() {
    fbm.subscribeToTopic('all');
    fbm.subscribeToTopic('agents');
    fbm.getToken().then((token) => print(token));
  }

  //final FirebaseAuth _auth = FirebaseAuth.instance;
  void initState() {
    _registerOnFirebase();
    getMessage();
    super.initState();
    startTimer();
  }

  startTimer() {
    Timer(Duration(seconds: 2), () async {
      if (await PrepApp.auth.currentUser() != null) {
        Route newRoute = MaterialPageRoute(builder: (_) => Home());
        Navigator.pushReplacement(context, newRoute);
      } else {
        /// Not SignedIn
        Route newRoute = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, newRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: SpinKitRotatingCircle(
            color: Colors.amber,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
