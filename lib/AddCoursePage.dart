import 'package:flutter/material.dart';

class AddCoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
        backgroundColor: Color(0xFF0F2C3E),
      ),
      body: Center(
        child: Text(
          'Course Addition Form Goes Here.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
