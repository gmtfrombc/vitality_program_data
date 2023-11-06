import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VP Data Analyzer'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  debugPrint('run analysis');
                },
                child: const Text('Run Analysis'),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'The number of participants in the last 30 days is: 50',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
