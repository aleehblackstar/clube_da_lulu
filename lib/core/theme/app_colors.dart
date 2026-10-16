import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds & Surfaces
  static const Color background = Color(0xFF0A1128);
  static const Color surface = Color(0xFF101B3A);
  static const Color surfaceLight = Color(0xFF1A2954);

  // Brand Colors (Extracted from Logo)
  static const Color primaryCyan = Color(0xFF00E5FF);
  static const Color accentPink = Color(0xFFFF4081);
  static const Color softBlue = Color(0xFF80DEEA);

  // Semantic aliases
  static const Color primary = primaryCyan;
  static const Color secondary = accentPink;
  static const Color accent = softBlue;

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8C7E0);
  static const Color textMuted = Color(0xFF7B8FA8);

  // Status Colors
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFCA28);
  static const Color error = Color(0xFFFF5252);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF101B3A),
      Color(0xFF0A1128),
      Color(0xFF070C1E),
    ],
  );
}
