import 'package:flutter/material.dart';

class DurationsProvider extends ChangeNotifier {
  Map<String, int> _durations = {
    'pomodoro': 3, // 25 minutes in seconds
    'shortBreak': 300, // 5 minutes in seconds
    'longBreak': 900, // 15 minutes in seconds
  };

  Map<String, int> get durations => _durations;

  void updateDurations(Map<String, int> newDurations) {
    _durations = newDurations;
    notifyListeners();
  }

  String getDurationInMinutes(String mode) {
    return (_durations[mode]! ~/ 60).toString();
  }

  void updateDuration(String mode, int newDuration) {
    _durations[mode] = newDuration;
    notifyListeners();
  }
}
