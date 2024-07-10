import 'package:flutter/material.dart';
import 'package:heal_anemia/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  ProfileViewPage({required this.userData});

  @override
  _ProfileViewPageState createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  @override
  void initState() {
    super.initState();
    // No need to load profile data here if it's passed directly in userData
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('phoneNumber');
    await prefs.remove('dob');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileItem('Name', widget.userData['name']),
            _buildProfileItem('Date of Birth', widget.userData['dob'].toString().substring(0, 10)),
            _buildProfileItem('Address', widget.userData['address']),
            _buildProfileItem('Phone Number', widget.userData['phoneNumber']),
            _buildProfileItem('Aadhar No', widget.userData['aadharNo']),
            _buildProfileItem('Gender', widget.userData['gender']),
            _buildProfileItem('Age', widget.userData['age'].toString()),
            _buildProfileItem('Height', '${widget.userData['height']} cm'),
            _buildProfileItem('Weight', '${widget.userData['weight']} kg'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'Logout',
                  
                  style: TextStyle(fontSize: 18,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:-',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
        Divider(color: Colors.grey[400], thickness: 1, height: 20),
      ],
    );
  }
}
