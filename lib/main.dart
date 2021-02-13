import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:groupchatapp/screens/ChatScreen.dart';
import 'package:groupchatapp/screens/LoginPage.dart';

import 'Widgets/LoadingScreen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: CheckLogin(),
    );
  }
}

class CheckLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LoadingScreen();
        if (!snapshot.hasData || snapshot.data == null) {
          return LoginPage();
        } else {
          String userId = snapshot.data.uid;

          final FirebaseFirestore _firestore = FirebaseFirestore.instance;
          DocumentReference ref = _firestore.collection('Users').doc(userId);

          ref.get().then((value) {
            if (value.exists) {
              String UserId = value.data()["U"];
              String UserName = value.data()["N"];

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                  (route) => false);
            } else {
              FirebaseAuth.instance.signOut();
            }
          });
        }
        return LoadingScreen();
      },
    );
  }
}
