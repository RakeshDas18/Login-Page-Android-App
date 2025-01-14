import 'package:flutter/material.dart';

class AppStyles {
  // Common button style
  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    minimumSize: Size(double.infinity, 50),  // Dynamic size
    backgroundColor: Color(0xff162d3a),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Common container style
  static BoxDecoration containerStyle = BoxDecoration(
    color: Color(0xff162d3a),
    borderRadius: BorderRadius.circular(8),
  );

  // Common text style
  static TextStyle textStyle({double fontSize = 14, Color color = Colors.black, FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
