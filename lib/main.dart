import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ClubeDaLuLuApp());
}

class ClubeDaLuLuApp extends StatelessWidget {
  const ClubeDaLuLuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clube da LuLu',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryCyan,
          secondary: AppColors.accentPink,
          tertiary: AppColors.softBlue,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        textTheme: AppTypography.textTheme,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}