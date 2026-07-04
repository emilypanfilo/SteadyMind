import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'settings_screen.dart';

final List<Color> pastelColors = [
  Color(0xFFBFA2DB),
  Color(0xFFA8D5BA),
  Color(0xFFFFC7A5),
  Color(0xFFAED9E0),
  Color(0xFFFFD6E8),
  Color(0xFFFFF3B0),
  Color(0xFFCDEAC0),
  Color(0xFFD6CDEA),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SteadyMindApp());
}

class SteadyMindApp extends StatelessWidget {
  const SteadyMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SteadyMIND',
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
  int studyLength = 1500;
  int secondsRemaining = 1500;
  int completedSessions = 0;

  Timer? timer;
  bool isRunning = false;

  late Color accentColor;

  @override
  void initState() {
    super.initState();
    accentColor = pastelColors[Random().nextInt(pastelColors.length)];
  }

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
          secondsRemaining = studyLength;
        }
      });

      if (secondsRemaining == studyLength && !isRunning) {
        await saveSessionToFirebase();
      }
    });
  }

    void pauseTimer() {
      timer?.cancel();

    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();

    setState(() {
      secondsRemaining = studyLength;
      isRunning = false;
    });
  }

  void changeThemeColor() {
    setState(() {
      accentColor =
          pastelColors[Random().nextInt(pastelColors.length)];
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: accentColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: changeThemeColor,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );

              if (result != null) {
                timer?.cancel();

                setState(() {
                  studyLength = result;
                  secondsRemaining = result;
                  isRunning = false;
                });
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Text(
                "SteadyMind",
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
                    color: accentColor,
                    width: 9,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(
                        0.45,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 55,
                      fontWeight:
                          FontWeight.bold,
                      color: Color(0xFF5D4E7B),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  buildTimerButton(
                    label: "Start",
                    icon: Icons.play_arrow,
                    onPressed: startTimer,
                  ),
                  buildTimerButton(
                    label: "Pause",
                    icon: Icons.pause,
                    onPressed: pauseTimer,
                  ),
                  buildTimerButton(
                    label: "Reset",
                    icon: Icons.refresh,
                    onPressed: resetTimer,
                  ),
                ],
              ),

              const SizedBox(height: 35),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(
                    0.8,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor
                          .withOpacity(0.25),
                      blurRadius: 12,
                      offset:
                          const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  "Completed Sessions: $completedSessions",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color(0xFF5D4E7B),
                    fontWeight:
                        FontWeight.w600,
                  ),
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

  Widget buildTimerButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15),
        ),
        elevation: 4,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}