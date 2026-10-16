import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _pulseController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowPulseAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(begin: 0.97, end: 1.02).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _glowPulseAnimation = Tween<double>(begin: 18.0, end: 34.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Base Dark Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),

          // Top Cyan Ambient Glow
          Positioned(
            top: -120,
            left: -60,
            right: -60,
            child: IgnorePointer(
              child: Container(
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryCyan.withValues(alpha: 0.38),
                      AppColors.primaryCyan.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Pink Ambient Glow
          Positioned(
            bottom: -140,
            left: -60,
            right: -60,
            child: IgnorePointer(
              child: Container(
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentPink.withValues(alpha: 0.42),
                      AppColors.accentPink.withValues(alpha: 0.14),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: [
                    const Spacer(flex: 3),

                    // Animated Circular Logo with Glowing Cyan Border
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surface,
                              border: Border.all(
                                color: AppColors.primaryCyan,
                                width: 3.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryCyan
                                      .withValues(alpha: 0.55),
                                  blurRadius: _glowPulseAnimation.value,
                                  spreadRadius: 3,
                                ),
                                BoxShadow(
                                  color: AppColors.accentPink
                                      .withValues(alpha: 0.18),
                                  blurRadius: _glowPulseAnimation.value * 1.4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Transform.scale(
                                // Slight scale to trim the white outer margin of logo.png
                                scale: 1.08,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Title "Clube da LuLu"
                    Text(
                      'Clube da LuLu',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayTitle.copyWith(
                        shadows: [
                          Shadow(
                            color: AppColors.accentPink.withValues(alpha: 0.45),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // Subtitle "Comunidade & Treinos"
                    Text(
                      'Comunidade & Treinos',
                      textAlign: TextAlign.center,
                      style: AppTypography.subtitle.copyWith(
                        shadows: [
                          Shadow(
                            color:
                                AppColors.primaryCyan.withValues(alpha: 0.25),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Circular Progress Indicator
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        backgroundColor:
                            AppColors.primaryCyan.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryCyan,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
