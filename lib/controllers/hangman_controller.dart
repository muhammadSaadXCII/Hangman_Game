import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/game_status.dart';

class HangmanController extends ChangeNotifier {
  String _targetWord = '';
  final Set<String> _correctLetters = {};
  final Set<String> _wrongLetters = {};
  GameStatus _status = GameStatus.loading;
  String _notificationMessage = '';

  GameStatus get status => _status;
  Set<String> get correctLetters => _correctLetters;
  Set<String> get wrongLetters => _wrongLetters;
  String get targetWord => _targetWord;
  int get wrongCount => _wrongLetters.length;
  String get notificationMessage => _notificationMessage;

  HangmanController() {
    startNewGame();
  }

  Future<void> startNewGame() async {
    _status = GameStatus.loading;
    _targetWord = '';
    _correctLetters.clear();
    _wrongLetters.clear();
    _notificationMessage = '';
    notifyListeners();

    try {
      final res = await http.get(
        Uri.parse('https://random-word-api.herokuapp.com/word?number=1'),
      );
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        String word = data[0].toString().toLowerCase();

        if (word.length > 10) {
          startNewGame();
        } else {
          _targetWord = word;
          _status = GameStatus.playing;
          notifyListeners();
        }
      }
    } catch (e) {
      _targetWord = 'flutter';
      _status = GameStatus.playing;
      notifyListeners();
    }
  }

  void makeGuess(String letter) {
    if (_status != GameStatus.playing || _targetWord.isEmpty) return;

    if (_targetWord.contains(letter)) {
      if (!_correctLetters.contains(letter)) {
        _correctLetters.add(letter);
      } else {
        _setTemporaryMessage("Already guessed '$letter'!");
      }
    } else {
      if (!_wrongLetters.contains(letter)) {
        _wrongLetters.add(letter);
      } else {
        _setTemporaryMessage("Already guessed '$letter'!");
      }
    }

    _checkWinCondition();
    notifyListeners();
  }

  void _checkWinCondition() {
    bool allGuessed = _targetWord
        .split('')
        .every((char) => _correctLetters.contains(char));

    if (allGuessed) {
      _status = GameStatus.won;
    } else if (_wrongLetters.length >= 6) {
      _status = GameStatus.lost;
    }
  }

  void _setTemporaryMessage(String msg) {
    _notificationMessage = msg;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 200), () {
      _notificationMessage = '';
      notifyListeners();
    });
  }
}
