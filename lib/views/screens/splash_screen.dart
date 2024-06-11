import 'package:flutter/material.dart';
import 'package:onlayn_magazin/services/auth_http_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authHttpServices = AuthHttpServices();

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    authHttpServices.checkAuth().then((value) {
      setState(() {
        isLoggedIn = value;
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, isLoggedIn ? '/home' : '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 150,
        ),
      ),
    );
  }
}
