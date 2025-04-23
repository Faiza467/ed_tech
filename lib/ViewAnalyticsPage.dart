import 'package:flutter/material.dart';

class ViewAnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Analytics'),
        backgroundColor: Color(0xFF0F2C3E),
      ),
      body: Center(
        child: Text(
          'Analytics Content Goes Here.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
