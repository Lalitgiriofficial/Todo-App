import 'package:flutter/material.dart';
import 'package:todo/Pages/AuthForm.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Authentication",
          style: TextStyle(color: Colors.white, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: AuthForm(),
    ));
  }
}
