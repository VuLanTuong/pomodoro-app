import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro/duration-provider.dart';
import 'package:provider/provider.dart';

class SettingTimeDialog extends StatefulWidget {
  final Map<String, int> durations;

  const SettingTimeDialog(
      {Key? key, required this.durations, required this.onDurationsChanged})
      : super(key: key);

  static Future<Map<String, int>> show(BuildContext context,
      {required Map<String, int> durations}) {
    final completer = Completer<Map<String, int>>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SettingTimeDialog(
          durations: durations,
          onDurationsChanged: (newDurations) {
            completer.complete(newDurations);
          },
        );
      },
    );
    return completer.future;
  }

  final void Function(Map<String, int>) onDurationsChanged;

  @override
  _SettingTimeDialogState createState() => _SettingTimeDialogState();
}

class _SettingTimeDialogState extends State<SettingTimeDialog> {
  late Map<String, int> modeDurations;
  late TextEditingController pomodoroController;
  late TextEditingController shortBreakController;
  late TextEditingController longBreakController;
  Map<String, int> durations = {};
  @override
  void initState() {
    super.initState();
    // modeDurations = {
    //   'pomodoro': 3, // 25 minutes in seconds
    //   'shortBreak': 300, // 5 minutes in seconds
    //   'longBreak': 900, // 15 minutes in seconds
    // };
    _initializeDurations();
    pomodoroController = TextEditingController(
      text: formatDuration(
          widget.durations['pomodoro'] ?? modeDurations['pomodoro']!),
    );
    shortBreakController = TextEditingController(
      text: formatDuration(
          widget.durations['shortBreak'] ?? modeDurations['shortBreak']!),
    );
    longBreakController = TextEditingController(
      text: formatDuration(
          widget.durations['longBreak'] ?? modeDurations['longBreak']!),
    );
  }

  void _initializeDurations() {
    DurationsProvider durationsProvider =
        Provider.of<DurationsProvider>(context, listen: false);
    setState(() {
      durations = Map.from(durationsProvider.getDurations());
    });
  }

  String formatDuration(int durationInSeconds) {
    if (durationInSeconds < 60) {
      final fraction = durationInSeconds / 60.0;
      return fraction.toStringAsFixed(2);
    } else {
      final minutes = durationInSeconds ~/ 60;
      return '$minutes';
    }
  }

  void saveSettings(
    BuildContext context,
    int pomodoroDuration,
    int shortBreakDuration,
    int longBreakDuration,
  ) {
    final durationsProvider =
        Provider.of<DurationsProvider>(context, listen: false);

    setState(() {
      durations['pomodoro'] = pomodoroDuration * 60;
      durations['shortBreak'] = shortBreakDuration * 60;
      durations['longBreak'] = longBreakDuration * 60;
    });

    // print('save $pomodoroDuration');
    // print('save $shortBreakDuration');
    // print('save $longBreakDuration');

    final updatedDurations = durations;
    // print('update $pomodoroDuration');
    durationsProvider.updateDurations(updatedDurations);
    durationsProvider.saveDurations(updatedDurations);

    Navigator.of(context).pop();
  }

  void resetToDefault() {
    final durationsProvider =
        Provider.of<DurationsProvider>(context, listen: false);
    setState(() {
      durations = Map<String, int>.from(modeDurations);
      pomodoroController.text =
          (widget.durations['pomodoro']! ~/ 60).toString();
      shortBreakController.text =
          (widget.durations['shortBreak']! ~/ 60).toString();
      longBreakController.text =
          (widget.durations['longBreak']! ~/ 60).toString();
    });

    durations = modeDurations;
    durationsProvider.updateDurations(modeDurations);
  }

  void updateDuration(String key, int value) {
    setState(() {
      durations[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pomodoro Duration:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: pomodoroController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minutes',
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$')),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Short Break Duration:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: shortBreakController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minutes',
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$')),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Long Break Duration:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: longBreakController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minutes',
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$')),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final int pomodoroDuration =
                        int.tryParse(pomodoroController.text) ??
                            (durations['pomodoro'] ??
                                    modeDurations['pomodoro'])! ~/
                                60;
                    final int shortBreakDuration =
                        int.tryParse(shortBreakController.text) ??
                            (durations['shortBreak'] ??
                                    modeDurations['shortBreak'])! ~/
                                60;
                    final int longBreakDuration =
                        int.tryParse(longBreakController.text) ??
                            (durations['longBreak'] ??
                                    modeDurations['longBreak'])! ~/
                                60;

                    saveSettings(context, pomodoroDuration, shortBreakDuration,
                        longBreakDuration);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: resetToDefault,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
