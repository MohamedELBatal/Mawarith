import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mwareth/home.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "Splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Create a timer that navigates to the next screen after 10 seconds
    Timer(const Duration(seconds: 5), () {
      // Navigate to the next screen
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white30,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
