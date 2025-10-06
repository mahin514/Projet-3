import 'package:flutter/material.dart';

void main() => runApp(const SweatlyApp());

class SweatlyApp extends StatelessWidget {
  const SweatlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sweatly',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C55D7),
        useMaterial3: true,
      ),

      home: const LoginPage(),
    );
  }
}


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Text(
          'LOGIN',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 28, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
