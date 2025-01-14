import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_page.dart';
import 'styles.dart';  // Import the styles file

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged in with Google!')));

      // Navigate to HomePage on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  Future<void> _signInWithEmailPassword() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged in successfully!')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        default:
          errorMessage = e.message ?? 'An unknown error occurred.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred. Please try again later.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back! 👋',
                style: AppStyles.textStyle(fontSize: screenWidth * 0.08, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                "Please log in to continue",
                style: AppStyles.textStyle(fontSize: screenWidth * 0.045, color: Colors.grey[600]!),
              ),
              SizedBox(height: screenHeight * 0.05),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: AppStyles.textStyle(fontSize: screenWidth * 0.04, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "example@gmail.com",
                        hintStyle: TextStyle(fontSize: 12),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(fontSize: screenWidth * 0.045),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: AppStyles.textStyle(fontSize: screenWidth * 0.04, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
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
                      style: TextStyle(fontSize: screenWidth * 0.045),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signInWithEmailPassword();
                        }
                      },
                      style: AppStyles.buttonStyle,
                      child: Text(
                        'Login',
                        style: AppStyles.textStyle(fontSize: screenWidth * 0.045, color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Center(
                      child: Text("or sign in with", style: AppStyles.textStyle(fontSize: screenWidth * 0.04)),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _signInWithGoogle,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: AppStyles.containerStyle,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/google.png',
                                  height: screenHeight * 0.05,
                                  width: screenHeight * 0.05,
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                Text(
                                  'Google',
                                  style: AppStyles.textStyle(fontSize: screenWidth * 0.04, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.06),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: AppStyles.containerStyle,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/facebook.png',
                                height: screenHeight * 0.05,
                                width: screenHeight * 0.05,
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Text(
                                'Facebook',
                                style: AppStyles.textStyle(fontSize: screenWidth * 0.04, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
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
                                style: AppStyles.textStyle(fontSize: screenWidth * 0.045),
                              ),
                              TextSpan(
                                text: "Sign Up",
                                style: AppStyles.textStyle(
                                  fontSize: screenWidth * 0.05,
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
