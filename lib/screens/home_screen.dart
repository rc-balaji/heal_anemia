import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'foods_to_improve.dart';
import 'sign_up_screen.dart';
import 'item_card.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          ItemCard(
            title: 'LOGIN',
            image: 'assets/iconz.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>LoginPage()),
              );
            },
          ),
          // ItemCard(
          //   title: 'REGISTER',
          //   // image: 'assets/causes.png',
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) =>  SignUpPage()),
          //     );
          //   },
          // ),
          ItemCard(
            title: 'Anemia',
            image: 'assets/iconz.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Item2Screen()),
              );
            },
          ),
          
          // Add more ItemCards here
        ],
      ),
    );
  }
}


