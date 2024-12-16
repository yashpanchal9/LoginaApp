import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  String? location;

  void updateProfile({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String location,
  }) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.dateOfBirth = dateOfBirth;
    this.location = location;
    notifyListeners();
  }
}
