// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:async';

// import 'package:pomodoro/my_helper.dart';

// void main() {
//   runApp(PomodoroApp());
// }

// class PomodoroApp extends StatelessWidget {
//   const PomodoroApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pomodoro Timer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PomodoroScreen(),
//     );
//   }
// }

// class PomodoroScreen extends StatefulWidget {
//   const PomodoroScreen({super.key});

//   @override
//   _PomodoroScreenState createState() => _PomodoroScreenState();
// }

// class _PomodoroScreenState extends State<PomodoroScreen> {
//   // These are suggested initial values for the Pomodoro timer.
//   static const String POMODORO = "pomodoro";
//   static const String SHORT_BREAK = "shortBreak";
//   static const String LONG_BREAK = "longBreak";

//   Color buttonsColor = MyHelper.button;
//   Color buttonsColorOnPress = MyHelper.buttonOnPress;

//   int _pomodoroDuration = 25;
//   int _shortBreakDuration = 5;
//   int _longBreakDuration = 10;

//   int _remainingTime = 0;

//   bool _isWorking = true;
//   bool _isShortBreak = false;
//   bool _isLongBreak = false;

//   int _completedCycles = 0;
//   int _cyclesUntilLongBreak = 4;

//   int minutes = 0;
//   int seconds = 0;

//   late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//   }

//   void _initializeNotifications() {
//     // TODO: Initialize FlutterLocalNotificationsPlugin
//   }

//   void _startTimer() {
//     int totalSeconds;
//     if (_isWorking) {
//       totalSeconds = _pomodoroDuration * 60;
//     } else if (_isShortBreak) {
//       totalSeconds = _shortBreakDuration * 60;
//     } else if (_isLongBreak) {
//       totalSeconds = _longBreakDuration * 60;
//     } else {
//       return; // No mode selected, exit the function
//     }

//     minutes = totalSeconds ~/ 60;
//     seconds = totalSeconds % 60;

//     const oneSec = const Duration(seconds: 1);
//     Timer.periodic(oneSec, (Timer timer) {
//       if (totalSeconds <= 0) {
//         timer.cancel();
//         if (_isWorking) {
//           _showNotification('Pomodoro', 'Pomodoro is completed');
//           _isShortBreak = true;
//         } else if (_isShortBreak) {
//           _showNotification('Short Break', 'Short Break is completed');
//           _isWorking = true;
//         } else if (_isLongBreak) {
//           _showNotification('Long Break', 'Long Break is completed');
//           _isWorking = true;
//         }
//       } else {
//         minutes = totalSeconds ~/ 60;
//         seconds = totalSeconds % 60;
//         totalSeconds--;
//       }
//     });
//   }

//   void _resetTimer() {
//     _pomodoroDuration = 25;
//     _shortBreakDuration = 5;
//     _longBreakDuration = 10;
//   }

//   void _configureDurations() {
//     // TODO: Implement the logic to show dialog to configure durations
//   }

//   void _showNotification(String title, String body) {
//     // TODO: Implement the logic to show a local notification
//     // Display a local notification when each interval is completed, informing
//     // the user about the end of the Pomodoro, Short Break, or Long Break.
//     print('Notification: $title - $body');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pomodoro Timer'),
//       ),
//       body: Container(
//         color: Colors.blue.shade200,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Pomodoro, Short Break, and Long Break buttons
//                   // ----------------------------------------------
//                   // When user taps Pomodoro, it should be selected and pomodoro
//                   // counter should start.
//                   //
//                   // When counter reaches 0, a notification should be shown,
//                   //
//                   // If completed cycles is less than cycles until long break,
//                   // short break counter should start.
//                   // Otherwise, long break counter should start.
//                   _buildButton('pomodoro', _isWorking, () {
//                     _isWorking = true;
//                     _isShortBreak = false;
//                     _isLongBreak = false;
//                     _showNotification("work", "Pomodoro is completed");
//                   }),
//                   SizedBox(width: 10),
//                   // When user taps Short Break, it should be selected and short break counter should start.
//                   //
//                   // When counter reaches 0, a notification should be shown,
//                   // and pomodoro counter should start again.
//                   _buildButton('short break', _isShortBreak, () {
//                     _isWorking = false;
//                     _isShortBreak = true;
//                     _isLongBreak = false;
//                     _showNotification("short", "Pomodoro is completed");
//                   }),
//                   // When user taps Long Break, it should be selected and long break counter should start.
//                   // When counter reaches 0, a notification should be shown,
//                   // and pomodoro counter should start again.
//                   SizedBox(width: 10),
//                   _buildButton('long break', _isLongBreak, () {
//                     _isWorking = false;
//                     _isShortBreak = false;
//                     _isLongBreak = true;
//                     _showNotification("long", "Pomodoro is completed");
//                   }),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Text(
//                 '$minutes:$seconds',
//                 style: TextStyle(
//                   fontSize: 80,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _startTimer,
//                 child: Text('start'),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.black,
//                   backgroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     onPressed: _resetTimer,
//                     icon: Icon(Icons.refresh),
//                     color: Colors.white,
//                   ),
//                   SizedBox(width: 10),
//                   IconButton(
//                     onPressed: _configureDurations,
//                     icon: Icon(Icons.settings),
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildButton(String text, bool isSelected, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       child: Text(
//         text,
//         style: TextStyle(color: isSelected ? Colors.white : Colors.black),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isSelected ? Colors.blue : Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//     );
//   }
// }
