import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FocusFlowApp());
}

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FocusFlow',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F3FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFBFA2DB),
        ),
      ),
      home: const TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int secondsRemaining = 5;
  int completedSessions = 0;

  Timer? timer;
  bool isRunning = false;

  Future<void> saveSessionToFirebase() async {
    await FirebaseFirestore.instance.collection('sessions').add({
      'completedSessions': completedSessions,
      'totalMinutes': completedSessions * 25,
      'createdAt': Timestamp.now(),
    });
  }

  void startTimer() {
    if (isRunning) return;

    isRunning = true;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
          isRunning = false;
          completedSessions++;
          secondsRemaining = 5;
        }
      });

      if (secondsRemaining == 5 && !isRunning) {
        await saveSessionToFirebase();
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    isRunning = false;
  }

  void resetTimer() {
    timer?.cancel();

    setState(() {
      secondsRemaining = 5;
      isRunning = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = secondsRemaining ~/ 60;
    int seconds = secondsRemaining % 60;

    String time =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SteadyMIND",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFDCC6F2),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Study Timer",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4E7B),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF7FB),
                  border: Border.all(
                    color: const Color(0xFFBFA2DB),
                    width: 9,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFD8C7E8),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4E7B),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: startTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Start"),
                  ),
                  ElevatedButton.icon(
                    onPressed: pauseTimer,
                    icon: const Icon(Icons.pause),
                    label: const Text("Pause"),
                  ),
                  ElevatedButton.icon(
                    onPressed: resetTimer,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset"),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                "Completed Sessions: $completedSessions",
                style: const TextStyle(
                  fontSize: 22,
                  color: Color(0xFF5D4E7B),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Stay focused.\nOne session at a time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF7B6D9C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}