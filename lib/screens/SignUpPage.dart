import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupchatapp/Widgets/ProgressButton.dart';
import 'package:toast/toast.dart';

import 'ChatScreen.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController textEditingController1 = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();
  TextEditingController textEditingController3 = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/chat.jpeg',
                width: 100,
                height: 100,
              ),
            ),
            Center(
                child: Text(
              "Group Chat App",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 50,
            ),
            Center(
                child: Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.indigo,
                  fontWeight: FontWeight.w500),
            )),
            SizedBox(
              height: 10,
            ),
            TextFieldWidget("Name", textEditingController1),
            TextFieldWidget("Email", textEditingController2),
            PassWidget("Password", textEditingController3),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
              child: buildTextWithIcon(),
            ),
            SizedBox(
              height: 20,
            ),
            _rowTextWidget(),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  ButtonState stateTextWithIcon = ButtonState.idle;

  Widget buildTextWithIcon() {
    return ProgressButton.icon(
        iconedButtons: {
          ButtonState.idle: IconedButton(
            text: 'SIGN UP',
            icon: Icon(Icons.send, color: Colors.indigo),
            color: Colors.white,
          ),
          ButtonState.loading: IconedButton(
            text: "Loading",
            color: Colors.deepPurple.shade700,
          ),
          ButtonState.fail: IconedButton(
              text: "Failed",
              icon: Icon(Icons.cancel, color: Colors.white),
              color: Colors.red),
          ButtonState.success: IconedButton(
              text: "Success",
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400)
        },
        onPressed: onPressedIconWithText,
        textStyle1: TextStyle(color: Colors.indigo),
        textStyle2: TextStyle(color: Colors.white),
        textStyle3: TextStyle(color: Colors.white),
        state: stateTextWithIcon);
  }

  void onPressedIconWithText() async {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        if (textEditingController1.text.isNotEmpty &&
            textEditingController2.text.isNotEmpty &&
            textEditingController3.text.isNotEmpty) {
          setState(() {
            stateTextWithIcon = ButtonState.loading;
          });

          try {
            dynamic result = await _auth.createUserWithEmailAndPassword(
                email: textEditingController2.text.trim(),
                password: textEditingController3.text);

            if (result == null) {
              Toast.show("Email Id could not be created", context);
            } else {
              String re = result.toString();
              print('Uid =====> $re');

              final FirebaseAuth _auth = FirebaseAuth.instance;
              User user = await _auth.currentUser;

              if (user != null) {
                db.collection("Users").doc(user.uid).set({
                  "N": textEditingController1.text.trim(),
                  "U": user.uid,
                  "E": textEditingController2.text.trim(),
                  "T": "E"
                }).then((value) {
                  Toast.show("Profile Created ", context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                      (route) => false);
                });
              }
            }

            print(" V --- " + result.toString());
          } catch (error) {
            switch (error.code) {
              case "ERROR_INVALID_EMAIL":
                print("Your email address appears to be malformed.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_WRONG_PASSWORD":
                print("Your password is wrong.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_USER_NOT_FOUND":
                print("User with this email doesn't exist.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_USER_DISABLED":
                print("User with this email has been disabled.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_TOO_MANY_REQUESTS":
                print("Too many requests. Try again later.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_OPERATION_NOT_ALLOWED":
                print("Signing in with Email and Password is not enabled.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              default:
                print("An undefined Error happened.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
            }
          }
        } else {
          Toast.show("Please Enter Username, Email & Pass ", context);
        }

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(() {
      stateTextWithIcon = stateTextWithIcon;
    });
  }

  Widget TextFieldWidget(
      String hint, TextEditingController textEditingController) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 60),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.black),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              controller: textEditingController,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.indigo,
                focusColor: Colors.indigo,
                hoverColor: Colors.indigo,
                labelText: hint,
                contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0)),
                disabledBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget PassWidget(String hint, TextEditingController textEditingController) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 60),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.black),
            child: TextField(
              obscureText: true,
              keyboardType: TextInputType.name,
              maxLines: 1,
              controller: textEditingController,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.black,
                focusColor: Colors.black,
                hoverColor: Colors.black,
                labelText: hint,
                contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0)),
                disabledBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowTextWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Have an account?",
          style: TextStyle(fontSize: 16, color: Colors.indigo[400]),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Sign In",
            style: TextStyle(
                fontSize: 16,
                color: Colors.indigo,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
