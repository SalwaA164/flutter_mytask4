
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, SetOptions;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mytask4/Screens/home_layout.dart';
import 'package:flutter_mytask4/widgets/myTextFormField.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<RegisterScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController namedC = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController ConfirmPasswordC = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  // ignore: non_constant_identifier_names
  Future<void> Register({
    required String email,
    required String pass,
    required String name,
    // ignore: non_constant_identifier_names
    required String ConfirmPassword,
  }) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass)
            .then(
          (value) {
            if (value.user != null) {
              saveUserData(
                email,
                pass,
                name,
                ConfirmPassword,
                value.user!.uid,
              ).then((value) {
                if (value) {
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
              });
            }
          },
        );
      } catch (e) {
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

  Future<bool> saveUserData(
    String email,
    String pass,
    String name,
    // ignore: non_constant_identifier_names
    String ConfirmPassword,
    String uid,
  ) async {
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'userName': name,
        'userEmail': email,
        'userPass': pass,
        'userPhone': ConfirmPassword,
        'uid': uid,
        'image': '',
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
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
          child: Column(
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
              
              const SizedBox(
                height: 50,
              ),
              MyFormFiled(
                controller: namedC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'name must be not empty';
                  }
                  return null;
                },
                hintText: 'Username',
                prefixIcon: const Icon(
                  Icons.person,
                ),
              ),
              MyFormFiled(
                controller: emailC,
                validator: (value) {
                  if (!value!.contains('@ict')) {
                    return 'must contain @ict';
                  }
                  return null;
                },
                hintText: 'email',
                prefixIcon: const Icon(
                  Icons.email,
                ),
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
                prefixIcon: const Icon(
                  Icons.password,
                ),
              ),
              MyFormFiled(
                controller: ConfirmPasswordC,
                validator: (value) {
                  if (value!.length < 6) {
                    return 'ConfirmPassword must be 6 ';
                  }
                  return null;
                },
                hintText: 'ConfirmPassword',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.password,
                ),
              ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Register(
                          pass: passwordC.text,
                          email: emailC.text,
                          ConfirmPassword: ConfirmPasswordC.text,
                          name: namedC.text,
                        );
                        FocusScope.of(context).unfocus();
                      },
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const Text(
                        'Register',
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
