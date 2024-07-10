import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const ItemCard({
    Key? key,
    required this.title,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        splashColor: Color(0xFFA8DADC),  // Light Blue splash color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // First section with image
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(image, width: 60, height: 60),
              ),
            ),
            // Second section with text and icon
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0)),
                color: Color.fromARGB(255, 57, 190, 230),  // Highlight color (e.g., red)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,  // White text color
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
