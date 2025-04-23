import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddCoursePage extends StatefulWidget {
  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final coverImageController = TextEditingController();
  List<TextEditingController> additionalFileControllers = [TextEditingController()];

  final database = FirebaseDatabase.instance.ref();

  void addCourse(BuildContext context) async {
    try {
      // Firebase automatically generates a unique ID
      String courseId = database.child('courses').push().key!;

      // Save course with an additional id field
      await database.child('courses').child(courseId).set({
        'id': courseId,  // Adding the generated course ID
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'coverImage': coverImageController.text.trim(),
        'additionalFiles': additionalFileControllers
            .map((controller) => controller.text.trim())
            .toList(), // Collect the list of file URLs
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course added successfully'),
          backgroundColor: Color(0xFF0F2C3E),
        ),
      );

      // Clear input fields after adding course
      titleController.clear();
      descriptionController.clear();
      coverImageController.clear();
      additionalFileControllers.forEach((controller) => controller.clear());
      additionalFileControllers = [TextEditingController()];  // Reset the file URL list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding course: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void addNewFileField() {
    setState(() {
      additionalFileControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F2C3E),
        title: Text(
          'Add Course',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Course Details",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2C3E),
                ),
              ),
              SizedBox(height: 30),
              _buildTextField('Course Title', titleController),
              SizedBox(height: 20),
              _buildBigTextField('Description', descriptionController),
              SizedBox(height: 20),
              _buildTextField('Cover Image URL', coverImageController),
              SizedBox(height: 20),
              // Display all additional file URL text fields
              Text(
                'Additional File URLs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2C3E),
                ),
              ),
              ...additionalFileControllers.map((controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildTextField('File URL', controller),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addNewFileField,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0F2C3E),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Add Another File URL',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => addCourse(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0F2C3E),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Add Course',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF0F2C3E)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0F2C3E)),
        ),
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.text_fields, color: Color(0xFF0F2C3E)),
      ),
    );
  }

  Widget _buildBigTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 5,  // Makes the field larger
      minLines: 3,  // Sets minimum lines
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF0F2C3E)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0F2C3E)),
        ),
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description, color: Color(0xFF0F2C3E)),
      ),
    );
  }
}
