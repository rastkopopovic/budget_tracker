import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'services/app_service.dart';
import 'models/budget_user.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp> {
  final AppService _appService = AppService();
  BudgetUser? _loggedUser;
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _loggedUser == null
        ? AuthScreen(
          appService: _appService,
          onLoginSuccess: (user) {
            setState((){
              _loggedUser = user;
            });
          },
        )
        : HomeScreen(
            user: _loggedUser!,
            appservice: _appService,
            onLogout: () {
              setState((){
                _loggedUser = null;
              });
            },
        )
    );
  }

}