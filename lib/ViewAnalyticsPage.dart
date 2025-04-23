import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewAnalyticsPage extends StatefulWidget {
  @override
  _ViewAnalyticsPageState createState() => _ViewAnalyticsPageState();
}

class _ViewAnalyticsPageState extends State<ViewAnalyticsPage> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> students = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    try {
      final coursesSnapshot = await database.child('courses').get();
      final usersSnapshot = await database.child('users').get();

      final fetchedCourses = <Map<String, dynamic>>[];
      final fetchedStudents = <Map<String, dynamic>>[];

      if (coursesSnapshot.exists) {
        coursesSnapshot.children.forEach((course) {
          fetchedCourses.add(Map<String, dynamic>.from(course.value as Map));
        });
      }

      if (usersSnapshot.exists) {
        usersSnapshot.children.forEach((user) {
          final userMap = Map<String, dynamic>.from(user.value as Map);
          if (userMap['role'] == 'Student') {
            fetchedStudents.add(userMap);
          }
        });
      }

      setState(() {
        courses = fetchedCourses;
        students = fetchedStudents;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching analytics data: $e');
    }
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (course['coverImage'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(course['coverImage'], height: 150, fit: BoxFit.cover),
              ),
            SizedBox(height: 10),
            Text("Title: ${course['title']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Description: ${course['description']}"),
            if (course['additionalFiles'] != null && course['additionalFiles'] is List)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text("Files:", style: TextStyle(fontWeight: FontWeight.w600)),
                  ...List.generate((course['additionalFiles'] as List).length, (index) {
                    final url = course['additionalFiles'][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(url, style: TextStyle(color: Colors.blue)),
                      ),
                    );
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${student['name']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Email: ${student['email']}"),
            Text("Phone: ${student['phone']}"),
            Text("Role: ${student['role']}"),
            Text("Joined: ${student['createdAt']}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Analytics',
          style: TextStyle(
            color: Colors.white, // Make the text white
          ),
        ),
        backgroundColor: Color(0xFF0F2C3E),
      )
      ,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All Courses', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F2C3E))),
            ...courses.map((c) => _buildCourseCard(c)).toList(),
            SizedBox(height: 20),
            Text('All Students', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F2C3E))),
            ...students.map((s) => _buildStudentCard(s)).toList(),
          ],
        ),
      ),
    );
  }
}
