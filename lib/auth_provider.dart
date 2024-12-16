import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String _otp = '1234'; // Mock OTP
  String? _loggedInUser;

  bool validateOTP(String inputOTP) {
    return inputOTP == _otp;
  }

  void login(String user) {
    _loggedInUser = user;
    notifyListeners();
  }

  String? get loggedInUser => _loggedInUser;
}
