import 'package:flutter/material.dart';
import 'package:heal_anemia/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define color variables for easy management
const primaryColor = Colors.blue;
const secondaryColor = Colors.purple;
const buttonColor = Colors.white;
const buttonTextColor = Colors.blue;
const textColor = Colors.white;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController aadharNoController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  DateTime? selectedDate;
  String gender = 'Male';
  final String ip = '192.168.1.7';
  bool isLoading = false;
  String message = '';

  Future<void> register(
    String name,
    String dob,
    String address,
    String phoneNumber,
    String aadharNo,
    String gender,
    String age,
    String height,
    String weight
  ) async {
    setState(() {
      isLoading = true;
      message = '';
    });

    final response = await http.post(
      Uri.parse('http://$ip:5000/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'dob': dob,
        'address': address,
        'phoneNumber': phoneNumber,
        'aadharNo': aadharNo,
        'gender': gender,
        'age': age,
        'height': height,
        'weight': weight
      }),
    );

    setState(() {
      isLoading = false;
      if (response.statusCode == 200) {
        message = 'Registration successful';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration successful'),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        message = 'Registration failed: ${jsonDecode(response.body)['message']}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: textColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: textColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: textColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: aadharNoController,
                  decoration: InputDecoration(
                    labelText: 'Aadhar No',
                    labelStyle: TextStyle(color: textColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: gender,
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue!;
                    });
                  },
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: TextStyle(color: textColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: primaryColor.withOpacity(0.8),
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    labelStyle: TextStyle(color: textColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: heightController,
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    labelStyle: TextStyle(color: textColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    labelStyle: TextStyle(color: textColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text(
                    "Date of Birth (YYYY-MM-DD)",
                    style: TextStyle(color: textColor),
                  ),
                  subtitle: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : "${selectedDate!.toLocal()}".split(' ')[0],
                    style: TextStyle(color: textColor),
                  ),
                  trailing: Icon(Icons.calendar_today, color: textColor),
                  onTap: () => _selectDate(context),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (selectedDate != null) {
                            register(
                              nameController.text,
                              selectedDate.toString(),
                              addressController.text,
                              phoneNumberController.text,
                              aadharNoController.text,
                              gender,
                              ageController.text,
                              heightController.text,
                              weightController.text,
                            );
                          } else {
                            setState(() {
                              message = 'Please select a date of birth';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please select a date of birth'),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: buttonTextColor,
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                        ),
                        child: Text('Register'),
                      ),
                SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
