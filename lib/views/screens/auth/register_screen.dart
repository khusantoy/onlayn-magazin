import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onlayn_magazin/services/auth_http_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authHttpServices = AuthHttpServices();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  String? email, password, passwordConfirm;
  bool isLoading = false;

  bool hidePasswordFiled = true;
  bool hideConfirmPasswordField = true;

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

      // register
      setState(() {
        isLoading = true;
      });

      try {
        await _authHttpServices.register(email!, password!);
        checkExpire();
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        String message = e.toString();

        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email is exists";
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
        title: const Text("Ro'yhatdan o'tish"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
                    return "Email kiriting";
                  } else if (!value.contains('@') || !value.contains('.')) {
                    return "Email to'g'ri emas";
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
                controller: _passwordController,
                textInputAction: TextInputAction.done,
                obscureText: hidePasswordFiled,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Parol",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePasswordFiled = !hidePasswordFiled;
                      });
                    },
                    icon: hidePasswordFiled
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Parol kiriting";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  // save password
                  password = newValue;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordConfirmController,
                textInputAction: TextInputAction.done,
                obscureText: hideConfirmPasswordField,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Parol tasdiqlang",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hideConfirmPasswordField = !hideConfirmPasswordField;
                      });
                    },
                    icon: hideConfirmPasswordField
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Parol kiriting";
                  } else if (_passwordConfirmController.text !=
                      _passwordController.text) {
                    return "Parol mos emas";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  // save password confirm
                  passwordConfirm = newValue;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: submit,
                        child: const Text("Ro'yhatdan o'tish"),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text("Kirish"),
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
