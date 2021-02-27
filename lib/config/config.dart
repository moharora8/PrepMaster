import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Color primaryColor =
//Color.fromRGBO(218, 40, 28, 0.7);
    Color(0xFF00F58D);
//Color(0xFFDA281C);
final Color secondaryColor =
//Color.fromRGBO(250, 40, 28, 0.7);
    Color(0xFF006572);
//Color(0xFFF9EE23);
//f9ee23

class PrepApp {
  // App Information
  static const String appName = 'Place Prep';
  static final String authtype = 'auth_type';
  // Firestore
  static SharedPreferences sharedPreferences;
  static FirebaseUser user;
  static FirebaseAuth auth;
  static Firestore firestore = Firestore.instance;

  // Firebase Collection name

  // static String collectionAllItems = "items";
  // static String userOrderList = 'userOrder';

  //Strings
  static String signInText = "Sign in using Phone Number";
  static String signIn = "Sign In";
  static String next = "Next";
  static String tapButton =
      "Tap Next to verify your account with phone number. "
      "You don`t need to enter verification code manually if number is installed in your phone";
  static String enterPhoneNumber = "Enter your phone number";
  static String sendSMS =
      "We will send an SMS message to verify your phone number.";
  static String enterName = "Enter your name";
  static String done = "Done";

//Firestore.instance.collection('users).document('uid).fields

  // User Detail
  static final String userName = 'name';
  static final String userissubscribed = 'is_subscribed';
  static final String userPhone = 'phonenumber';
  static final String userEmail = 'email';
  static final String userPhotoUrl = 'photoUrl';
  static final String userUID = 'uid';
  static final String userAvatarUrl = 'url';
  static final String userDocUrl = 'doc_url';
  static final String userJoinedTeams = 'joinedTeams';
  static final String usermethos = 'signin_method';
  static final String isverified = 'is_verified';
  static final String profilecreated = 'pofile_created';

  // Order fields
  // static final String addressID = 'addressID';
  // static final String totalAmount = 'totalAmount';
  // static final String productID = 'productIDs';
  // static final String paymentDetails = 'paymentDetails';
  // static final String orderTime = 'orderTime';
  // static final String isSuccess = 'isSuccess';
}
