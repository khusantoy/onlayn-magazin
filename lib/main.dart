import 'package:flutter/material.dart';
import 'package:onlayn_magazin/views/screens/auth/forgot_password_screen.dart';
import 'package:onlayn_magazin/views/screens/auth/login_screen.dart';
import 'package:onlayn_magazin/views/screens/auth/register_screen.dart';
import 'package:onlayn_magazin/views/screens/home_screen.dart';
import 'package:onlayn_magazin/views/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
