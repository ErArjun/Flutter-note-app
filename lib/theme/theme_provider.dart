import 'package:flutter/material.dart';
import 'package:note/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  //initially, theme is light mode
  ThemeData _themedata = lightMode;

  //getter method to access the theme from other parts of the code
  ThemeData get themeData => _themedata;

  //getter method to see if we are in dark mode or not
  bool get isDarkMode => _themedata == darkMode;

  //setter method to set the new theme
  set themeData(ThemeData themeData) {
    _themedata = themeData;
    notifyListeners();
  }

  //we will use this toggle in a switch later on..
  void toggleTheme() {
    if (_themedata == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
