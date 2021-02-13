import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitChasingDots(
                  color: Colors.indigo,
                  size: 50.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.indigo,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
