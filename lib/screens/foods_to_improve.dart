import 'package:flutter/material.dart';

class Item2Screen extends StatelessWidget {
  const Item2Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What is Anemia'),
      ),
      body: Center(
        child: Text('Content for What is Anemia'),
      ),
    );
  }
}
