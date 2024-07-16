import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, int> initialDurations;
  final Function(Map<String, int>) onDurationsUpdated;

  SettingsScreen({
    required this.initialDurations,
    required this.onDurationsUpdated,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Map<String, int> updatedDurations;

  @override
  void initState() {
    super.initState();
    updatedDurations = Map.from(widget.initialDurations);
  }

  void updateDuration(String mode, int newValue) {
    setState(() {
      updatedDurations[mode] = newValue;
    });
  }

  void saveSettings() {
    widget.onDurationsUpdated(updatedDurations);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pomodoro Duration:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              initialValue:
                  (widget.initialDurations['pomodoro']! ~/ 60).toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minutes',
              ),
              onChanged: (value) {
                final int? newValue =
                    int.tryParse(value) ?? widget.initialDurations['pomodoro'];
                updateDuration('pomodoro', newValue! * 60);
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Short Break Duration:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              initialValue:
                  (widget.initialDurations['shortBreak']! ~/ 60).toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minutes',
              ),
              onChanged: (value) {
                final int? newValue = int.tryParse(value) ??
                    widget.initialDurations['shortBreak'];
                updateDuration('shortBreak', newValue! * 60);
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Long Break Duration:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              initialValue:
                  (widget.initialDurations['longBreak']! ~/ 60).toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minutes',
              ),
              onChanged: (value) {
                final int? newValue =
                    int.tryParse(value) ?? widget.initialDurations['longBreak'];
                updateDuration('longBreak', newValue! * 60);
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Save Settings?',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Are you sure you want to save the settings?',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: saveSettings,
                                  child: Text('Save'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
