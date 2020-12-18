import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/config.dart';
import 'home.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:splashscreen/splashscreen.dart' as s;

void main() {
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
      darkTheme:
          ThemeData(brightness: Brightness.dark, primaryColor: primaryColor),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.onAuthStateChanged,
      builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          FirebaseUser user = snapshot.data;

          if (user != null) {
            return Home();
            //HomeScreen();
          } else {
            return LoginScreen();
          }
        }

        return LoginScreen();
      },
    );
  }
}
// class Splash2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen(
//       seconds: 6,
//       navigateAfterSeconds: new SecondScreen(),
//       title: new Text('GeeksForGeeks',textScaleFactor: 2,),
//       image: new Image.network('https://www.geeksforgeeks.org/wp-content/uploads/gfg_200X200.png'),
//       loadingText: Text("Loading"),
//       photoSize: 100.0,
//       loaderColor: Colors.blue,
//     );
//   }
// }
