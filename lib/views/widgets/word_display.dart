import 'package:flutter/material.dart';

class WordDisplay extends StatelessWidget {
  final String word;
  final Set<String> correctLetters;
  final bool revealAll;

  const WordDisplay({
    super.key,
    required this.word,
    required this.correctLetters,
    this.revealAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: word.split('').map((char) {
            bool isVisible = correctLetters.contains(char) || revealAll;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 45,
              height: 55,
              decoration: BoxDecoration(
                color: isVisible ? Colors.white : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  if (isVisible)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                isVisible ? char.toUpperCase() : '',
                style: const TextStyle(
                  fontSize: 32,
                  color: Color(0xFF764ba2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}