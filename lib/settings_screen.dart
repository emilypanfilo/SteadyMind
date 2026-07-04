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
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text("30 Minutes"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text("45 Minutes"),
              onTap: () {},
            ),

            const SizedBox(height: 30),

            const Text(
              "Break Time",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(Icons.coffee),
              title: const Text("5 Minutes"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.coffee),
              title: const Text("10 Minutes"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.coffee),
              title: const Text("15 Minutes"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}