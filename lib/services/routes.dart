import 'package:flutter/material.dart';
import 'package:app_specialbreeds/screens/welcome_screen.dart';
import 'package:app_specialbreeds/screens/login_screen.dart';
import 'package:app_specialbreeds/screens/register_screen.dart';
import 'package:app_specialbreeds/screens/home_screen.dart';
import 'package:app_specialbreeds/screens/schedule_screen.dart';
import 'package:app_specialbreeds/screens/gallery_screen.dart';
import 'package:app_specialbreeds/screens/MainScreen.dart';

class Routes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String schedule = '/schedule';
  static const String gallery = '/gallery';
  static const String main = '/main';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      schedule: (context) => const ScheduleScreen(),
      gallery: (context) => const GalleryScreen(),
      main: (context) => const MainScreen(),
    };
  }
}