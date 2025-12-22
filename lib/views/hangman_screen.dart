import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/hangman_controller.dart';
import '../models/game_status.dart';
import 'widgets/hangman_painter.dart';
import 'widgets/keyboard.dart';
import 'widgets/word_display.dart';

class HangmanGameScreen extends StatefulWidget {
  const HangmanGameScreen({super.key});

  @override
  State<HangmanGameScreen> createState() => _HangmanGameScreenState();
}

class _HangmanGameScreenState extends State<HangmanGameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<HangmanController>();

      controller.addListener(() {
        if (!mounted) return;

        if (controller.notificationMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                controller.notificationMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFFffb347),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        }

        if ((controller.status == GameStatus.won ||
                controller.status == GameStatus.lost) &&
            ModalRoute.of(context)?.isCurrent == true) {
          _showEndGameDialog(controller.status == GameStatus.won, controller);
        }
      });
    });
  }

  void _showEndGameDialog(bool won, HangmanController controller) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Game Over",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, anim1, __) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Column(
              children: [
                Text(won ? "🎉" : "💀", style: const TextStyle(fontSize: 50)),
                const SizedBox(height: 10),
                Text(
                  won ? "You Won!" : "Game Over",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  won ? "Great job guessing the word!" : "The word was:",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
                if (!won)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      controller.targetWord.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF764ba2),
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF764ba2),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.startNewGame();
                  },
                  child: const Text("Play Again"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HangmanController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            child: controller.status == GameStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "HANGMAN",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: controller.startNewGame,
                                      icon: const Icon(
                                        Icons.refresh,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SizedBox(
                                        height: 250,
                                        width: 200,
                                        child: CustomPaint(
                                          painter: HangmanPainter(
                                            wrongCount: controller.wrongCount,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: WordDisplay(
                              word: controller.targetWord,
                              correctLetters: controller.correctLetters,
                              revealAll: controller.status == GameStatus.lost,
                            ),
                          ),

                          SizedBox(height: 12),

                          Expanded(
                            flex: 4,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double keyboardWidth = constraints.maxWidth;
                                if (keyboardWidth > 660) keyboardWidth = 660;

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (controller.wrongLetters.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: Text(
                                          controller.wrongLetters
                                              .join('  ')
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(0xFFffb347),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),

                                    Expanded(
                                      child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: SizedBox(
                                            width: keyboardWidth,
                                            child: HangmanKeyboard(
                                              onLetterPressed:
                                                  controller.makeGuess,
                                              correctLetters:
                                                  controller.correctLetters,
                                              wrongLetters:
                                                  controller.wrongLetters,
                                              isDisabled:
                                                  controller.status !=
                                                  GameStatus.playing,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
