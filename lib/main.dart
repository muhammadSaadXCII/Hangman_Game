import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/hangman_controller.dart';
import 'views/hangman_screen.dart';

void main() {
  runApp(const HangmanApp());
}

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Segoe UI',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF764ba2),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => HangmanController(),
        child: const HangmanGameScreen(),
      ),
    );
  }
}
