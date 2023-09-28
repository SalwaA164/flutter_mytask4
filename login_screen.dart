import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mytask4/Screens/home_layout.dart';
import 'package:flutter_mytask4/Screens/Register_screen.dart';
import 'package:flutter_mytask4/widgets/myTextFormField.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> login({
    required String email,
    required String pass,
  }) async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass)
            .then(
          (value) {
            if (value.user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeLayout(),
                ),
                (route) => false,
              );
            }
          },
        );
      } on FirebaseException catch (e) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Form(
          key: formKey,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome Back!Glad to see you.Again!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
          ),
              ),
            
              MyFormFiled(
                controller: emailC,
                validator: (value) {
                  return null;
                },
                hintText: 'email',
              ),
              MyFormFiled(
                controller: passwordC,
                validator: (value) {
                  if (value!.length < 6) {
                    return 'password must be 6 ';
                  }
                  return null;
                },
                hintText: 'password',
              ),
              TextButton(
                onPressed: () {
                  login(
                    email: emailC.text,
                    pass: passwordC.text,
                  );
                  FocusScope.of(context).unfocus();
                },
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'You dont have an account?RegisterNow',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
