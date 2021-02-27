import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import '../Config/config.dart';
// import '../Config/config2.dart' as c;

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        //backgroundColor: Colors.transparent,

        //Color.fromRGBO(237, 237, 237, 1.0),
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          //c.primaryColor,
          //Colors.deepPurple,
          centerTitle: true,
          title: Text(
            PrepApp.appName,
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.person),
                text: "Google Auth",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Phone Auth',
              ),
            ],
            indicatorColor: Colors.pink,
            indicatorWeight: 5.0,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Login(),
            Register(),
          ],
        ),
      ),
    );
  }
}

//
//
//class SignInScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Text(PaintBallApp.sharedPreferences.get(PaintBallApp.userEmail)),
//    );
//  }
//}
