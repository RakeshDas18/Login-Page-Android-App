import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth package
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In package

void main() async {
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

  // Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google Sign-In method
  Future<void> _signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the login process
        return;
      }

      // Obtain the Google authentication
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential using the authentication
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      await _auth.signInWithCredential(credential);

      // Once signed in, navigate to the home page or dashboard
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged in with Google!')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 30),
              Text(
                "Please log in to continue",
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                        hintStyle: TextStyle(fontSize: 12),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
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
                        hintStyle: TextStyle(fontSize: 12),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                      style: TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text("or sign in with", style: TextStyle(fontSize: 15)),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _signInWithGoogle, // Trigger Google sign-in on tap
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: Color(0xff162d3a),
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
                                  style: TextStyle(fontSize: 15, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: Color(0xff162d3a),
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
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
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
                                style: TextStyle(fontSize: 17, color: Colors.black),
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
                    ),
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
