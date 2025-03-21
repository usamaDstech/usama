import 'dart:async';
import 'package:flutter/material.dart';

class OnBoardingProvider extends ChangeNotifier {
  void startTimer(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/homeScreen');
    });
  }
}
