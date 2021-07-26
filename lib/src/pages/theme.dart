import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      //brightness: Brightness.dark,
      //backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.blueAccent[100],
      accentColor: Colors.blueAccent[400],
      dialogBackgroundColor: Colors.blueGrey[100],
      //accentColor: Colors.white,
      //accentIconTheme: IconThemeData(color: Colors.black),
      //dividerColor: Colors.black12,
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.grey),
        headline2: TextStyle(color: Colors.grey),
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      )
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      //brightness: Brightness.dark,
      //backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.indigo[700],
      accentColor: Colors.indigo[700],
      dialogBackgroundColor: Colors.blueGrey[100],
      //accentColor: Colors.white,
      //accentIconTheme: IconThemeData(color: Colors.black),
      //dividerColor: Colors.black12,
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.grey),
        headline2: TextStyle(color: Colors.grey),
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      
    );
  }
}