import 'package:flutter/material.dart';

class HangmanPainter extends CustomPainter {
  final int wrongCount;
  HangmanPainter({required this.wrongCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double centerX = size.width / 2;

    final double scale = size.height / 250.0;

    canvas.save();
    canvas.translate(centerX, 0);
    canvas.scale(scale, scale);
    canvas.translate(-centerX, 0);

    canvas.drawLine(
      Offset(centerX - 80, 250),
      Offset(centerX - 20, 250),
      paint,
    );
    canvas.drawLine(Offset(centerX - 50, 250), Offset(centerX - 50, 20), paint);
    canvas.drawLine(Offset(centerX - 50, 20), Offset(centerX + 50, 20), paint);
    canvas.drawLine(
      Offset(centerX + 50, 20),
      Offset(centerX + 50, 50),
      paint..strokeWidth = 3,
    );

    final double ropeX = centerX + 50;

    if (wrongCount > 0) {
      canvas.drawCircle(Offset(ropeX, 70), 20, paint..strokeWidth = 5);
    }
    if (wrongCount > 1) {
      canvas.drawLine(Offset(ropeX, 90), Offset(ropeX, 150), paint);
    }
    if (wrongCount > 2) {
      canvas.drawLine(Offset(ropeX, 100), Offset(ropeX - 30, 130), paint);
    }
    if (wrongCount > 3) {
      canvas.drawLine(Offset(ropeX, 100), Offset(ropeX + 30, 130), paint);
    }
    if (wrongCount > 4) {
      canvas.drawLine(Offset(ropeX, 150), Offset(ropeX - 30, 200), paint);
    }
    if (wrongCount > 5) {
      canvas.drawLine(Offset(ropeX, 150), Offset(ropeX + 30, 200), paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HangmanPainter oldDelegate) =>
      oldDelegate.wrongCount != wrongCount;
}
