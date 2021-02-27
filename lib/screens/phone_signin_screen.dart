import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../config/config.dart';

class PhoneSignInScreen extends StatefulWidget {
  @override
  _PhoneSignInScreenState createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  PhoneNumber _phoneNumber;

  String _message;
  String _verificationId;

  bool _isSMSsent = false;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final Firestore _db = Firestore.instance;

  final TextEditingController _smsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Sign In"),
      ),
      body: SingleChildScrollView(
        child: AnimatedContainer(
          duration: Duration(
            milliseconds: 500,
          ),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
            top: 20,
          ),
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: InternationalPhoneNumberInput(
                    formatInput: false,
                    onInputChanged: (phoneNumberTxt) {
                      _phoneNumber = phoneNumberTxt;
                    },
                    inputBorder: OutlineInputBorder(),
                    initialCountry2LetterCode: 'IN',
                  )),
              _isSMSsent == true
                  ? Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: _smsController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "OTP here",
                          labelText: "OTP",
                        ),
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  : Container(),
              _isSMSsent == false
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _isSMSsent = true;
                        });
                        _verifyPhoneNumber();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: Center(
                            child: Text(
                          "Send OTP",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        _signInWithPhoneNumber();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: Center(
                            child: Text(
                          "Verify OTP",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      PrepApp.auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await PrepApp.auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber.phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final FirebaseUser user =
        (await PrepApp.auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await PrepApp.auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        PrepApp.firestore.collection('users').document(user.uid).setData({
          "phonenumber": user.phoneNumber,
          "lastseen": DateTime.now(),
          "signin_method": user.providerId
        }, merge: true);

        _message = 'Successfully signed in, uid: ' + user.uid;
        print(_message);
      } else {
        _message = 'Sign in failed';
      }
    });

    Navigator.pop(context);
  }
}
