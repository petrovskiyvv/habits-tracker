import 'package:flutter/material.dart';
import 'package:env_flutter/env_flutter.dart';
import 'pages/habits_list_page.dart';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit tracker',
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 223, 223, 223),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: const HabitsListPage(),
    );
  }
}
