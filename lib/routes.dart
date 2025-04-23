import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/gallery_screen.dart';

class Routes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String schedule = '/schedule';
  static const String gallery = '/gallery';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      schedule: (context) => const ScheduleScreen(),
      gallery: (context) => const GalleryScreen(),
    };
  }
} 