import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/Pages/AuthPage.dart';
import 'package:todo/Pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, usersnapshot) {
        if (usersnapshot.hasData) {
          return MaterialApp(
            theme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.black,
                splashColor: Colors.transparent),
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        } else {
          return MaterialApp(
            theme: ThemeData(
                brightness: Brightness.dark, primaryColor: Colors.black),
            debugShowCheckedModeBanner: false,
            home: AuthPage(),
          );
        }
      },
    );
  }
}
