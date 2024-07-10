import 'package:flutter/material.dart';
import 'package:heal_anemia/screens/foods_to_improve.dart';
import 'package:heal_anemia/screens/item_card.dart';
import 'package:heal_anemia/screens/login_screen.dart';
import 'package:heal_anemia/screens/sign_up_screen.dart';
import 'package:heal_anemia/screens/profile_view.dart'; // Import your ProfileViewPage
import 'package:heal_anemia/screens/hp_meter_page.dart'; // Import your HPMeterPage

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> userData; // Declare userData map

  DashboardPage({required this.userData}); // Constructor to receive userData

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard - ${userData['name']}'), // Display user's name in the app bar
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileViewPage(userData: userData)),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          ItemCard(
            title: 'HP Meter', // New item card for HP Meter
            image: 'assets/iconz.jpg', // Replace with your image asset path
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HPMeterPage(gender: userData['gender']=='Male'?'men' :'women' ,)),
              );
            },
          ),
        ],
      ),
    );
  }
}
