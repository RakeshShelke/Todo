import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Auth/registerPage.dart';

import '../Pages/homePage.dart';
import '../Service/authService.dart';
import '../Service/helperFunction.dart';
import '../Widget/widget.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = true;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController Email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Groupie",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Image.asset("assets/login.png"),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (value) {
                          setState(() {
                            email = value.trim();
                          });
                        },
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "Please enter valid email";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: showPassword,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (showPassword) {
                                    showPassword = false;
                                  } else {
                                    showPassword = true;
                                  }
                                });
                              },
                              icon: Icon(showPassword == true
                                  ? Icons.remove_red_eye_sharp
                                  : Icons.remove_done_outlined),
                              color: Theme.of(context).primaryColor),
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              login();
                            },
                            child: const Text(
                              'Sign In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Register Here",
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const RegisterPage());
                                  })
                          ]))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginUserWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunction.saveUserLogged(true);
          await HelperFunction.saveUserEmail(email);

          nextScreenReplace(context, Home());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
