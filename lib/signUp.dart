import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login.dart';

class signUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<signUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  late FirebaseAuth firebaseAuth;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  String _selectedRole = 'Student';

  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF123456), // DARK BACKGROUND
      appBar: AppBar(
        backgroundColor: Colors.white, // Switched to WHITE
        title: Text(
          'Create Your Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F2C3E), // Switched to DARK COLOR
          ),
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
                "Welcome!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Please fill in the form to create your account.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 30),

              _buildTextField(nameController, "Name", Icons.person),
              SizedBox(height: 20),
              _buildTextField(phoneController, "Phone Number", Icons.phone, keyboardType: TextInputType.phone),
              SizedBox(height: 20),
              _buildTextField(emailController, "Email", Icons.email, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 20),
              _buildTextField(passwordController, "Password", Icons.lock, obscureText: true),
              SizedBox(height: 30),

              Text(
                "Sign up as:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              ListTile(
                title: Text('Student', style: TextStyle(color: Colors.white)),
                leading: Radio<String>(
                  value: 'Student',
                  groupValue: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                  activeColor: Colors.white,
                ),
              ),
              ListTile(
                title: Text('Tutor', style: TextStyle(color: Colors.white)),
                leading: Radio<String>(
                  value: 'Tutor',
                  groupValue: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                  activeColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String name = nameController.text.trim();
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    String phone = phoneController.text.trim();
                    String role = _selectedRole;

                    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && phone.isNotEmpty) {
                      try {
                        UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        await _database.child('users').child(userCredential.user!.uid).set({
                          'name': name,
                          'email': email,
                          'phone': phone,
                          'role': role,
                          'createdAt': DateTime.now().toIso8601String(),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration successful as $role')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Error: $e'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("All fields are required!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    elevation: 5,
                  ),
                  child: Text("Sign Up", style: TextStyle(fontSize: 18, color: Color(0xFF123456))),
                ),
              ),
              SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => login())),
                  child: Text(
                    "Already have an account? Login here.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white10,
      ),
    );
  }
}
