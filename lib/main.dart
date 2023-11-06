import 'package:flutter/material.dart';
import 'package:pm_data_analysis/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  //this is stuff added as an example to get familiar with github
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}
