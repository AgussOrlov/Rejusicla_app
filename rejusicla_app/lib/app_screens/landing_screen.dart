import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rejusicla_app/app_screens/auth_screen.dart';
import 'package:rejusicla_app/app_screens/home_screen.dart';
import 'package:rejusicla_app/loading_widget.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null)
            return AuthScreen();
          else
            return HomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: circularProgress(),
            ),
          );
        }
      },
    );
  }
}
