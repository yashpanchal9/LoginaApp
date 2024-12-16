import 'package:flutter/material.dart';
import 'package:login_auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  final _errors = <String, String?>{
    'firstName': null,
    'lastName': null,
    'location': null,
    'date': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              ModalRoute.withName('/'),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Profile Details',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  icon: Icons.person,
                  errorKey: 'firstName',
                  textCapitalization: TextCapitalization.words),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  icon: Icons.person,
                  errorKey: 'lastName',
                  textCapitalization: TextCapitalization.words),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _locationController,
                  label: 'Current Location',
                  icon: Icons.location_on,
                  errorKey: 'location'),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: _selectedDate?.toString().split(' ')[0] ?? 'Date of Birth',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      errorText: _errors['date'],
                      prefixIcon: const Icon(Icons.calendar_today, color: Colors.teal),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  backgroundColor: Colors.teal,
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 18)),
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
    required String errorKey,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextField(
      controller: controller,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        errorText: _errors[errorKey],
        prefixIcon: Icon(icon, color: Colors.teal),
      ),
    );
  }

  void _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    setState(() => _selectedDate = pickedDate);
  }

  void _submitProfile() {
    setState(() {
      _errors['firstName'] =
      _firstNameController.text.isEmpty ? 'First Name is required' : null;
      _errors['lastName'] =
      _lastNameController.text.isEmpty ? 'Last Name is required' : null;
      _errors['location'] =
      _locationController.text.isEmpty ? 'Location is required' : null;
      _errors['date'] = _selectedDate == null ? 'Date of Birth is required' : null;
    });

    if (_errors.values.every((error) => error == null)) {
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Created'),
        content: Text(
          'Name: ${_firstNameController.text} ${_lastNameController.text}\n'
              'DOB: ${_selectedDate.toString().split(' ')[0]}\n'
              'Location: ${_locationController.text}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearFields();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _locationController.clear();
    setState(() => _selectedDate = null);
  }
}
