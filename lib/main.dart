import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart'; // Import LoginPage

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
      home: LoginPage(), // Set LoginPage as the home screen
    );
  }
}
