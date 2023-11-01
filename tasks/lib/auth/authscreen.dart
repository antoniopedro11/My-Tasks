// Mestrado - Computação Móvel
// ToDo App
// António Velez nº18390 - 07/02/2023
//-----------------------------------
import 'package:flutter/material.dart';
import 'package:tasks/auth/authform.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Autenticação - ToDo App')),
      body: AuthForm(),
    );
  }
}
