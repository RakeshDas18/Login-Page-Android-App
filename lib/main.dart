import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts package

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(), // Apply Roboto globally using Google Fonts
        scaffoldBackgroundColor: Color(0xFFFFFFFF), // Set background color to white (#FFFFFF)
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TextEditingController for username and password fields
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Password visibility toggle
  bool _isPasswordVisible = false;

  // Form key to validate fields
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Removed title to hide the "Login" text
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back! 👋',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 30), // Reduced space above welcome text

              // Added a small description text between the Welcome text and email field
              Text(
                "Please log in to continue",
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 30), // Space before email label

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email label (increased font size)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 08),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "example@email.com",
                        hintStyle: TextStyle(fontSize: 12), // Reduced hint text size
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Reduced height
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(fontSize: 16), // Reduced text field font size
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Password label (increased font size)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 08),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "At least 8 characters",
                        hintStyle: TextStyle(fontSize: 12), // Reduced hint text size
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Reduced height
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(fontSize: 16), // Reduced text field font size
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40),

                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logging in...')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Color(0xff162d3a),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Same border radius as the Google/Facebook container
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // "Sign in with" text
                    Center(
                      child: Text("or sign in with", style: TextStyle(fontSize: 15)),
                    ),
                    SizedBox(height: 20),

                    // Google and Facebook icons with gap and background color
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Button
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            color: Color(0xff162d3a), // Background color
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/google.png',
                                height: 35,
                                width: 35,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'Google',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 25), // Gap between Google and Facebook buttons

                        // Facebook Button
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: Color(0xff162d3a), // Background color
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/facebook.png',
                                height: 35,
                                width: 35,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'Facebook',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Don't have an account? Sign Up text
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to Sign Up page
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
