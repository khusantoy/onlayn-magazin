import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onlayn_magazin/services/auth_http_services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final authHttpServices = AuthHttpServices();
  final _formKey = GlobalKey<FormState>();

  String? email;

  bool isLoading = false;
  bool isSuccess = false;

  void reset() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        await authHttpServices.resetPassword(email!);

        setState(() {
          isSuccess = true;
        });

        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.pop(context);
          },
        );
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
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
        title: const Text("Parolni tiklash"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  suffixIcon: isSuccess
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email ni kiriting";
                  } else if (!value.contains('@') || !value.contains('.')) {
                    return "Email to'g'ri emas";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  email = newValue;
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
                        onPressed: reset,
                        child: const Text("Yuborish"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
