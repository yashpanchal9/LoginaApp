import 'package:flutter/material.dart';
import 'package:login_auth/profile_screen.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false, _showOTPField = false;
  String? _mobileError, _otpError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Welcome Back!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Text('Please login to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center),
              const SizedBox(height: 32),
              _buildTextField(
                controller: _mobileController,
                label: 'Mobile Number',
                icon: Icons.phone,
                maxLength: 10,
                errorText: _mobileError,
                inputType: TextInputType.phone,
              ),
              if (_showOTPField) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _otpController,
                  label: 'Enter OTP',
                  icon: Icons.lock,
                  maxLength: 4,
                  errorText: _otpError,
                  inputType: TextInputType.number,
                ),
              ],
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _showOTPField ? () => _validateOTP(context) : _sendOTP,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  backgroundColor: Colors.teal,
                ),
                child: Text(_showOTPField ? 'Login' : 'Send OTP',
                    style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required int maxLength,
    String? errorText,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        errorText: errorText,
        prefixIcon: Icon(icon, color: Colors.teal),
      ),
    );
  }

  void _sendOTP() {
    setState(() {
      _mobileError = _mobileController.text.length == 10 ? null : 'Please enter a valid 10-digit mobile number';
      if (_mobileError == null) _showOTPField = true;
    });
  }

  void _validateOTP(BuildContext context) {
    setState(() {
      _otpError = _otpController.text == '1234' ? null : 'Invalid OTP. Please try again';
      if (_otpError == null) _isLoading = true;
    });

    if (_otpError == null) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.validateOTP(_otpController.text)) {
          authProvider.login(_mobileController.text);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        }
      });
    }
  }
}
