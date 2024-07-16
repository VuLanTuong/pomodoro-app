import 'package:flutter/material.dart';
import 'package:pomodoro/duration-provider.dart';
import 'package:pomodoro/my_helper.dart';
import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:pomodoro/setting_time_dialog.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => DurationsProvider(),
      child: PomodoroApp(),
    ),
  );
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pomodoro Timer',
        theme: ThemeData(),
        home: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.5,
              colors: [Colors.yellow, Colors.blue],
              stops: [0.4, 1.0],
            ),
          ),
          child: PomodoroScreen(),
        ));
  }
}

class PomodoroScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  // These are suggested initial values for the Pomodoro timer.

  String timeText = '';

  String currentMode = "pomodoro";

  late Map<String, int> modeDurations;
  Map<String, int> durations = {};

  late int durationInSeconds;
  Timer? countdownTimer;

  Color buttonsColorOnPress = MyHelper.primaryColor;
  Color buttonsColor = MyHelper.secondaryColor;
  Color accentColor = MyHelper.accentColor;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();

    modeDurations = {
      'pomodoro': 3, // 25 minutes in seconds
      'shortBreak': 300, // 5 minutes in seconds
      'longBreak': 900, // 15 minutes in seconds
    };

    durationInSeconds = modeDurations[currentMode]!;
    durations = Map.from(modeDurations);

    // DurationsProvider durationsProvider =
    //     Provider.of<DurationsProvider>(context, listen: false);
    // if (durationsProvider.durations.isEmpty) {
    //   durationsProvider.updateDurations(modeDurations);
    // }
  }

  void _initializeNotifications() async {
    // TODO: Initialize FlutterLocalNotificationsPlugin
  }

  void _startTimer() {
    countdownTimer?.cancel(); // Cancel any existing timer
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (durationInSeconds > 0) {
          durationInSeconds--;

          DurationsProvider durationsProvider =
              Provider.of<DurationsProvider>(context, listen: false);
          durationsProvider.updateDuration(currentMode, durationInSeconds);
        } else {
          timer.cancel(); // Stop the timer when the duration reaches 0
          _resetTimer();
          countdownTimer = null;
          _showNotification(currentMode);
        }
      });
    });
  }

  void _resetTimer() {
    // TODO: Implement the logic to reset the timer
    // Reset the timer to its initial state, clearing any ongoing intervals and
    // resetting the completed cycles count.
    DurationsProvider durationsProvider =
        Provider.of<DurationsProvider>(context, listen: false);
    setState(() {
      countdownTimer?.cancel();
      durationInSeconds = modeDurations[currentMode]!;
      durationsProvider.updateDuration(currentMode, durationInSeconds);
      countdownTimer = null;
    });
  }

  void _configureDurations() {
    // TODO: Implement the logic to show dialog to configure durations
  }

  void _showNotification(String mode) {
    // TODO: Implement the logic to show a local notification
    // Display a local notification when each interval is completed, informing
    // the user about the end of the Pomodoro, Short Break, or Long Break.
    if (html.Notification.supported) {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification(mode);
          html.window.alert('Completed $mode');
        } else {
          print('Notification permission denied.');
        }
      });
    } else {
      print('Notifications are not supported in this browser.');
    }
  }

  Widget _buildTimerText() {
    return Consumer<DurationsProvider>(
      builder: (context, durationsProvider, _) {
        durations = durationsProvider.durations;
        durationInSeconds = durationsProvider.durations[currentMode]!;

        int minutes = durationInSeconds ~/ 60; // Get the minutes
        int seconds = durationInSeconds % 60; // Get the remaining seconds

        timeText = '$minutes:${seconds.toString().padLeft(2, '0')}';
        return Text(
          timeText,
          style: const TextStyle(
            fontSize: 80,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$timeText | Pomodoro Timer'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(150, 244, 255, 1),
              Color.fromARGB(255, 0, 84, 153),
              Color.fromARGB(255, 252, 238, 109),
            ],
            stops: [0.1, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pomodoro, Short Break, and Long Break buttons
                  // ----------------------------------------------
                  // When user taps Pomodoro, it should be selected and pomodoro
                  // counter should start.
                  //
                  // When counter reaches 0, a notification should be shown,
                  //
                  // If completed cycles is less than cycles until long break,
                  // short break counter should start.
                  // Otherwise, long break counter should start.
                  _buildButton('pomodoro',
                      isSelected: currentMode == 'pomodoro'),
                  const SizedBox(width: 10),
                  // When user taps Short Break, it should be selected and short break counter should start.
                  //
                  // When counter reaches 0, a notification should be shown,
                  // and pomodoro counter should start again.
                  _buildButton('short break',
                      isSelected: currentMode == 'shortBreak'),
                  // When user taps Long Break, it should be selected and long break counter should start.
                  // When counter reaches 0, a notification should be shown,
                  // and pomodoro counter should start again.
                  const SizedBox(width: 10),
                  _buildButton('long break',
                      isSelected: currentMode == 'longBreak'),
                ],
              ),
              const SizedBox(height: 20),
              // Text(
              //   '25:00',
              //   style: TextStyle(
              //     fontSize: 80,
              //     color: Colors.white,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              _buildTimerText(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (countdownTimer != null) {
                    countdownTimer?.cancel();
                    countdownTimer = null;
                  } else {
                    _startTimer();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  countdownTimer != null ? 'Pause' : 'Start',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      final updatedDurations = await SettingTimeDialog.show(
                          context,
                          durations: durations);
                      // Code to be executed after the dialog is closed
                    },
                    icon: const Icon(Icons.settings),
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, {bool isSelected = false}) {
    DurationsProvider durationsProvider =
        Provider.of<DurationsProvider>(context, listen: false);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (text == 'pomodoro') {
            currentMode = 'pomodoro';
            durationInSeconds = modeDurations['pomodoro']!;
          } else if (text == 'short break') {
            currentMode = 'shortBreak';
            durationInSeconds = modeDurations['shortBreak']!;
          } else if (text == 'long break') {
            currentMode = 'longBreak';
            durationInSeconds = modeDurations['longBreak']!;
          }

          countdownTimer?.cancel();
          countdownTimer = null;
          durationInSeconds = modeDurations[currentMode]!;
          durationsProvider.updateDuration(currentMode, durationInSeconds);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Color.fromARGB(255, 223, 101, 0) : buttonsColorOnPress,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(100, 50),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
