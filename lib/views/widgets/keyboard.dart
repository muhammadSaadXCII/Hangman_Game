import 'package:flutter/material.dart';

class HangmanKeyboard extends StatelessWidget {
  final Function(String) onLetterPressed;
  final Set<String> correctLetters;
  final Set<String> wrongLetters;
  final bool isDisabled;

  const HangmanKeyboard({
    super.key,
    required this.onLetterPressed,
    required this.correctLetters,
    required this.wrongLetters,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: List.generate(26, (index) {
        String char = String.fromCharCode(index + 97);
        bool isCorrect = correctLetters.contains(char);
        bool isWrong = wrongLetters.contains(char);
        bool isAlreadyGuessed = isCorrect || isWrong;

        return SizedBox(
          width: 44,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              elevation: isAlreadyGuessed ? 0 : 2,
              backgroundColor: isAlreadyGuessed
                  ? (isCorrect ? Colors.greenAccent.withOpacity(0.8) : Colors.redAccent.withOpacity(0.5))
                  : Colors.white,
              foregroundColor: isAlreadyGuessed ? Colors.white : const Color(0xFF764ba2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: (isDisabled || isAlreadyGuessed) ? null : () => onLetterPressed(char),
            child: Text(
              char.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        );
      }),
    );
  }
}