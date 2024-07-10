import 'package:flutter/material.dart';
import 'package:heal_anemia/screens/sign_up_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart'; // Import your DashboardPage
import 'profile_view.dart'; // Import your ProfileViewPage

// Define color variables for easy management
const primaryColor = Colors.blue;
const secondaryColor = Colors.purple;
const buttonColor = Colors.white;
const buttonTextColor = Colors.blue;
const textColor = Colors.white;
const successColor = Colors.green;
const errorColor = Colors.red;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController phoneNumberController = TextEditingController();
  DateTime? selectedDate;
  final String ip = '192.168.1.7';
  bool isLoading = false;
  String message = '';

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();

    // Check if user is already logged in
    checkLoggedIn();
  }

  Future<void> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phoneNumber');
    String? dob = prefs.getString('dob');
    if (phoneNumber != null && dob != null) {
      // Directly navigate to Dashboard if credentials exist
      login(phoneNumber, dob);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> login(String phoneNumber, String dob) async {
    setState(() {
      isLoading = true;
      message = '';
    });

    final response = await http.post(
      Uri.parse('http://$ip:5000/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber, 'dob': dob}),
    );

    setState(() {
      isLoading = false;
      if (response.statusCode == 200) {
        // Store credentials locally
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('phoneNumber', phoneNumber);
          prefs.setString('dob', dob);
        });

        // Fetch user data after successful login
        var responseData = jsonDecode(response.body);
        var userData = responseData['user'];
        navigateToDashboard(userData);
      } else {
        message = 'Login failed: ${jsonDecode(response.body)['message']}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: errorColor,
        ));
      }
    });
  }

  void navigateToDashboard(dynamic userData) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(userData: userData),
      ),
    );
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 20),
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
                              login(
                                phoneNumberController.text,
                                selectedDate.toString(),
                              );
                            } else {
                              setState(() {
                                message = 'Please select a date of birth';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please select a date of birth'),
                                backgroundColor: errorColor,
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: buttonTextColor,
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black,
                          ),
                          child: Text('Login'),
                        ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: textColor),
                    ),
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
      ),
    );
  }
}
