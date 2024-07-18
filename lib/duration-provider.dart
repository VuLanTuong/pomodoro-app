import 'package:flutter/material.dart';

class DurationsProvider extends ChangeNotifier {
  Map<String, int> _durations = {};

  Map<String, int> init = {};

  Map<String, int> get durations => _durations;

  Map<String, int> getDurations() {
    if (_durations.isEmpty || init.isEmpty) {
      init = {
        'pomodoro': 1500, // 25 minutes in seconds
        'shortBreak': 300, // 5 minutes in seconds
        'longBreak': 900, // 15 minutes in seconds
      };

      _durations = Map.from(init);
    }
    return _durations;
  }

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

  int getDurationByMode(String mode) {
    return durations[mode]!;
  }

  int getInitDurationByMode(String mode) {
    return init[mode]!;
  }

  Map<String, int> resetDurations() {
    notifyListeners();
    print("resetting durations $init");
    init = {
      'pomodoro': 1500, // 25 minutes in seconds
      'shortBreak': 300, // 5 minutes in seconds
      'longBreak': 900, // 15 minutes in seconds
    };
    _durations = Map.from(init);
    return init;
  }

  void saveDurations(Map<String, int> newDurations) {
    init = Map.from(newDurations);
  }
}
