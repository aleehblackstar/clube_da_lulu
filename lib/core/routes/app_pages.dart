import 'package:get/get.dart';
import 'app_routes.dart';
import 'auth_middleware.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const Scaffold(
        body: Center(child: Text('Tela de Login (Em breve)')),
      ),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const Scaffold(
        body: Center(child: Text('Tela Principal (Protegida)')),
      ),
      middlewares: [AuthMiddleware()],
    ),
  ];
}