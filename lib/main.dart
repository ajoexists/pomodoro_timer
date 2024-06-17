import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_timer/view/pomodoro_page.dart';
import 'package:pomodoro_timer/viewmodel/pomodoro_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PomodoroViewModel(),
      child: MaterialApp(
        title: 'Pomodoro Timer',
        debugShowCheckedModeBanner: false,
        home: const PomodoroPage(),
      ),
    );
  }
}
