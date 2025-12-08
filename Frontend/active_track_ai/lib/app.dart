import 'package:active_track_ai/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';

class ActiveTrackApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return MaterialApp(
      title: 'ActiveTrack AI',
      theme: AppTheme.lightTheme,
      home: authState.isAuthenticated ? DashboardScreen() : ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
