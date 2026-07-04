import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFFDCC6F2),
      ),
      backgroundColor: const Color(0xFFF7F3FF),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Study Time",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text("25 Minutes"),
              onTap: () {
                Navigator.pop(context, 1500);
              },
            ),

            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text("30 Minutes"),
              onTap: () {
                Navigator.pop(context, 1800);
              },
            ),

            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text("45 Minutes"),
              onTap: () {
                Navigator.pop(context, 2700);
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "Break Time",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Break timer coming soon.",
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            const ListTile(
              leading: Icon(Icons.coffee),
              title: Text("5 Minutes"),
            ),

            const ListTile(
              leading: Icon(Icons.coffee),
              title: Text("10 Minutes"),
            ),

            const ListTile(
              leading: Icon(Icons.coffee),
              title: Text("15 Minutes"),
            ),
          ],
        ),
      ),
    );
  }
}