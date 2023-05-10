import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:untitled/Auth/loginPage.dart';
import 'package:untitled/Constant/constant.dart';
import 'Pages/homePage.dart';
import 'Service/helperFunction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ChatApp());
}

class ChatApp extends StatefulWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  bool _isSignIn = false;

  @override
  void initState() {
    super.initState();
    getUserStatus();
  }

  getUserStatus() async {
    await HelperFunction.getUserLogged().then((value) {
      if (value != null) {
        setState(() {
          _isSignIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Constant().primaryColor),
      home: _isSignIn ? Home() : const LoginPage(),
    );
  }
}
