import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/customTextField.dart';
import '../dialogs/errorDialog.dart';
import '../dialogs/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../home.dart';
import '../screens/home_screen.dart';
import '../screens/home_screen.dart';
import '../Config/config.dart';
// as c;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import '../config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Firestore firestore = Firestore.instance;
  void _signInUsingGoogle() async {
    // try {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print("Current User " + currentUser.uid);
    if (currentUser != null) {
      //
      writeDataToDataBase(currentUser);
      // .then((s) {
      //Navigator.pop(context);

      Route newRoute = MaterialPageRoute(
          builder: (_) => Home(
              //currentIndex: 2,
              ));
      Navigator.pushReplacement(context, newRoute);
      // });

      _message = 'Successfully signed in, uid: ' + currentUser.uid;

      print(_message);
    } else {
      _message = 'Sign in failed';
    }
    // }
    //  catch (e) {

    // }
  }

  final _fbm = FirebaseMessaging();
  String _message = '';
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Future<void> uploadImage() async {
    _phoneController.text.isNotEmpty && _phoneController.text.length == 10
        // &&
        //         _passwordController.text.isNotEmpty
        ? _signInUsingGoogle()
        //_login()
        : showDialog(
            context: context,
            builder: (con) {
              return ErrorAlertDialog(
                message: 'Please fill the correct number',
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        // ignore: unused_local_variable
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Login to your account',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    maxlength: 10,
                    type1: TextInputType.number,
                    data: Icons.phone,
                    controller: _phoneController,
                    hintText: 'Phone',
                    isObsecure: false,
                  ),
                  // CustomTextField(
                  //   data: Icons.lock_outline,
                  //   controller: _passwordController,
                  //   hintText: 'Password',
                  //   isObsecure: true,
                  // ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadImage();
              },
              color: Theme.of(context).primaryColor,
              //Colors.redAccent,
              child: Text('Log in'),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 3,
              width: _screenWidth * 0.8,
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  writeDataToDataBase(FirebaseUser currentUser) async {
    PrepApp.sharedPreferences = await SharedPreferences.getInstance();
    String reduced_uid = currentUser.uid.substring(0, 4);
    print(reduced_uid);
    String fcmToken = await _fbm.getToken();
    if (fcmToken != null) {
      firestore.collection("users").document(reduced_uid).setData({
        PrepApp.userUID: reduced_uid,
        PrepApp.userEmail: currentUser.email,
        PrepApp.userPhone: _phoneController.text,
        PrepApp.userName: currentUser.displayName,
        PrepApp.userAvatarUrl: currentUser.photoUrl,
        // 'token': fcmToken,
        'profilecreatedAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        //PrepApp.isSubscribe: false,
      }, merge: true);
      firestore
          .collection("users")
          .document(reduced_uid)
          .collection('tokens')
          .document(fcmToken)
          .setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        //PrepApp.isSubscribe: false,
      }, merge: true);
    } else {
      firestore.collection("users").document(reduced_uid).setData({
        PrepApp.userUID: reduced_uid,
        PrepApp.userEmail: currentUser.email,
        PrepApp.userPhone: _phoneController.text,
        PrepApp.userName: currentUser.displayName,
        PrepApp.userAvatarUrl: currentUser.photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        //PrepApp.isSubscribe: false,
      }, merge: true);
    }

    await PrepApp.sharedPreferences.setString(PrepApp.userUID, reduced_uid);
    await PrepApp.sharedPreferences.setString(PrepApp.authtype, 'gauth');
    await PrepApp.sharedPreferences
        .setString(PrepApp.userEmail, currentUser.email);
    await PrepApp.sharedPreferences
        .setString(PrepApp.userPhone, _phoneController.text);
    await PrepApp.sharedPreferences
        .setString(PrepApp.userName, currentUser.displayName);
    await PrepApp.sharedPreferences
        .setString(PrepApp.userAvatarUrl, currentUser.photoUrl);
    //Check for subscription status
    //
    //   DocumentReference _db2 = firestore
    //       .collection("users")
    //       .document(
    //           PrepApp.sharedPreferences.getString(PrepApp.userUID));

    //   _db2.get().then((DocumentSnapshot documentSnapshot) {
    //     if (documentSnapshot.exists) {
    //       print('Document data: ${documentSnapshot.data}');
    //       print('Subscribe:  ');
    //       print(documentSnapshot.data['is_subscribe']);
    //       if (documentSnapshot.data['is_subscribe'] == true) {
    //         PrepApp.sharedPreferences
    //             .setString(PrepApp.isSubscribe, 'true');
    //       } else {
    //         PrepApp.sharedPreferences
    //             .setString(PrepApp.isSubscribe, 'false');
    //       }
    //     } else {
    //       print('Document does not exist on the database');
    //     }
    //   });
    // }

    showMyDialog(String message) {
      showDialog(
          context: context,
          builder: (con) {
            return ErrorAlertDialog(
              message: message,
            );
          });
    }

    void _login() async {
      showDialog(
          context: context,
          builder: (con) {
            return LoadingAlertDialog(
              message: 'Please wait',
            );
          });
      FirebaseUser currentUser;
      await _auth
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((auth) {
        currentUser = auth.user;
      }).catchError((error) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (con) {
              return ErrorAlertDialog(
                message: error.message.toString(),
              );
            });
      });
      if (currentUser != null) {
        readDataToDataBase(currentUser).then((s) {
          Navigator.pop(context);
          // ignore: todo
          // TODO navigate to homescreen

          Route newRoute = MaterialPageRoute(
              builder: (_) => Home(
                  // currentIndex: 2,
                  ));
          Navigator.pushReplacement(context, newRoute);
        });
      } else {
        //   _success = false;
      }
    }
  }

  Future readDataToDataBase(FirebaseUser currentUser) async {
    String reduced_uid = currentUser.uid.substring(0, 4);
    await firestore
        .collection("users")
        .document(reduced_uid)
        .get()
        .then((snapshot) async {
      print(snapshot.data);
      await PrepApp.sharedPreferences
          .setString(PrepApp.userUID, snapshot.data[PrepApp.userUID]);
      await PrepApp.sharedPreferences
          .setString(PrepApp.userEmail, snapshot.data[PrepApp.userEmail]);
      await PrepApp.sharedPreferences
          .setString(PrepApp.userName, snapshot.data[PrepApp.userName]);
      await PrepApp.sharedPreferences.setString(
          PrepApp.userAvatarUrl, snapshot.data[PrepApp.userAvatarUrl]);
      // print(snapshot.data[PrepApp.userCartList]);
      //List<String> cart = snapshot.data[PrepApp.userCartList].cast<String>();
      // await PrepApp.sharedPreferences
      //     .setStringList(PrepApp.userCartList, cart);
    });
//      .setData({
//    DeliveryApp.userUID: reduced_uid,
//    DeliveryApp.userEmail: currentUser.email,
//  });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
}
