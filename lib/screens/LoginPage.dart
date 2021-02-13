import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:groupchatapp/Widgets/ProgressButton.dart';
import 'package:groupchatapp/screens/SignUpPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupchatapp/main.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController textEditingController1 = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name = '', email = '';
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Image.asset(
                "assets/chat.jpeg",
                height: 100,
                width: 100,
              )),
            ),
            Text(
              "Group Chat App",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Sign In With Email/Pass",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            TextFieldWidget("Email", textEditingController1),
            PassWidget("Password", textEditingController2),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
              child: buildTextWithIcon(),
            ),
            //_buttonWidget(),
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

  Widget _rowTextWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have account?",
          style: TextStyle(fontSize: 16, color: Colors.indigo[400]),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 16,
                color: Colors.indigo,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  ButtonState stateTextWithIcon = ButtonState.idle;
  Widget buildTextWithIcon() {
    return ProgressButton.icon(
        iconedButtons: {
          ButtonState.idle: IconedButton(
            text: 'SIGN IN',
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
            textEditingController2.text.isNotEmpty) {
          setState(() {
            stateTextWithIcon = ButtonState.loading;
          });

          try {
            dynamic result = await _auth
                .signInWithEmailAndPassword(
                    email: textEditingController1.text.trim(),
                    password: textEditingController2.text)
                .whenComplete(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => CheckLogin()),
                  (route) => false);
            });

            print(" V --- " + result.toString());
          } catch (error) {
            switch (error.code) {
              case "ERROR_INVALID_EMAIL":
                Toast.show(
                    "Your email address appears to be malformed.", context);

                print("Your email address appears to be malformed.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_WRONG_PASSWORD":
                Toast.show("Your password is wrong.", context);

                print("Your password is wrong.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_USER_NOT_FOUND":
                Toast.show("User with this email doesn't exist.", context);

                print("User with this email doesn't exist.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_USER_DISABLED":
                Toast.show("User with this email has been disabled.", context);

                print("User with this email has been disabled.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_TOO_MANY_REQUESTS":
                Toast.show("Too many requests. Try again later.", context);

                print("Too many requests. Try again later.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              case "ERROR_OPERATION_NOT_ALLOWED":
                Toast.show("Signing in with Email and Password is not enabled.",
                    context);

                print("Signing in with Email and Password is not enabled.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
                break;
              default:
                Toast.show("An undefined Error happened.", context);

                print("An undefined Error happened.");
                setState(() {
                  stateTextWithIcon = ButtonState.fail;
                });
            }
          }
        } else {
          Toast.show("Please Enter Email & Pass", context);
        }

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        break;
      case ButtonState.fail:
        setState(() {
          stateTextWithIcon = ButtonState.idle;
        });
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
}
