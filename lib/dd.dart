import 'package:flutter/material.dart';

class MidtermClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Expanded(
            child: ListView(),
          ),
          const Text('I have an error')
        ],
      ),
    );
  }
}
