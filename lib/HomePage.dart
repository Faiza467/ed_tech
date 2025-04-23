import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void fetchCourses() async {
    final snapshot = await database.child('courses').get();
    if (snapshot.exists) {
      final courseMap = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        courses = courseMap.values.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.user['name']}'),
        backgroundColor: Color(0xFF0F2C3E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: courses.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            final additionalFiles = List<String>.from(course['additionalFiles'] ?? []);

            return Card(
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (course['coverImage'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          course['coverImage'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    SizedBox(height: 12),
                    Text(
                      course['title'] ?? '',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(course['description'] ?? ''),
                    SizedBox(height: 8),
                    if (additionalFiles.isNotEmpty) ...[
                      Text(
                        'Additional Files:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...additionalFiles.map((fileUrl) => Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          fileUrl,
                          style: TextStyle(color: Colors.blue),
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            );
          },
        )

      ),
    );
  }
}
