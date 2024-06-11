import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onlayn_magazin/services/auth_http_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authHttpServices = AuthHttpServices();

  bool isLoading = false;

  bool hidePasswordField = true;

  String? email;
  String? password;

  void checkExpire() {
    Timer(const Duration(seconds: 3600), handleTimeout);
  }

  void handleTimeout() {
    AuthHttpServices.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      try {
        await _authHttpServices.login(email!, password!);
        checkExpire();

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        String message = e.toString();

        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email is exists";
        } else if (e.toString().contains("INVALID_LOGIN_CREDENTIALS")) {
          message = "User not found";
        }
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(message),
            );
          },
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kirish"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter your email";
                  } else if (!value.contains('@') || !value.contains('.')) {
                    return "Email is not correct";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  // save email
                  email = newValue;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textInputAction: TextInputAction.done,
                obscureText: hidePasswordField,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Parol",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePasswordField = !hidePasswordField;
                      });
                    },
                    icon: Icon(hidePasswordField
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please, enter your password";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  // save password
                  password = newValue;
                },
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/forgot-password'),
                child: const Text("Parolni unutdim"),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: submit,
                  child: const Text('Kirish'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/register'),
                    child: const Text("Ro'yhatdan o'tish"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
