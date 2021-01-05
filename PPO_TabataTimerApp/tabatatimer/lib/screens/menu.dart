import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';
import '../widgets/utils.dart';
import '../widgets/durationpicker.dart';
import 'settings.dart';
import 'tabata.dart';

class TabataScreen extends StatefulWidget {
  final Settings settings;
  final SharedPreferences prefs;
  final Function onSettingsChanged;

  TabataScreen({
    @required this.settings,
    @required this.prefs,
    @required this.onSettingsChanged,
  });

  @override
  State<StatefulWidget> createState() => _TabataScreenState();
}

class _TabataScreenState extends State<TabataScreen> {
  Tabata _tabata;

  @override
  initState() {
    var json = widget.prefs.getString('tabata');
    _tabata = json != null ? Tabata.fromJson(jsonDecode(json)) : defaultTabata;
    super.initState();
  }

  _onTabataChanged() {
    setState(() {});
    _saveTabata();
  }

  _saveTabata() {
    widget.prefs.setString('tabata', jsonEncode(_tabata.toJson()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TabataTimerApp'),
        leading: Icon(Icons.timer),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                      settings: widget.settings,
                      onSettingsChanged: widget.onSettingsChanged),
                ),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Подходы'),
            subtitle: Text('${_tabata.sets}'),
            leading: Icon(Icons.fitness_center),
            onTap: () {
              showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return NumberPickerDialog.integer(
                    minValue: 1,
                    maxValue: 10,
                    initialIntegerValue: _tabata.sets,
                    title: Text('Выберите количество подходов...'),
                  );
                },
              ).then((sets) {
                if (sets == null) return;
                _tabata.sets = sets;
                _onTabataChanged();
              });
            },
          ),
          ListTile(
            title: Text('Отдых'),
            subtitle: Text('${_tabata.reps}'),
            leading: Icon(Icons.repeat),
            onTap: () {
              showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return NumberPickerDialog.integer(
                    minValue: 1,
                    maxValue: 10,
                    initialIntegerValue: _tabata.reps,
                    title: Text('Кол-во повторов в каждом подходе...'),
                  );
                },
              ).then((reps) {
                if (reps == null) return;
                _tabata.reps = reps;
                _onTabataChanged();
              });
            },
          ),
          Divider(
            height: 10,
          ),
          ListTile(
            title: Text('Начало обратного отсчёта'),
            subtitle: Text(formatTime(_tabata.startDelay)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.startDelay,
                    title: Text('Обратный отсчёт перед началом'),
                  );
                },
              ).then((startDelay) {
                if (startDelay == null) return;
                _tabata.startDelay = startDelay;
                _onTabataChanged();
              });
            },
          ),
          ListTile(
            title: Text('Время работы'),
            subtitle: Text(formatTime(_tabata.exerciseTime)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.exerciseTime,
                    title: Text('Время выполнения работы'),
                  );
                },
              ).then((exerciseTime) {
                if (exerciseTime == null) return;
                _tabata.exerciseTime = exerciseTime;
                _onTabataChanged();
              });
            },
          ),
          ListTile(
            title: Text('Время отдыха'),
            subtitle: Text(formatTime(_tabata.restTime)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.restTime,
                    title: Text('Время отдыха'),
                  );
                },
              ).then((restTime) {
                if (restTime == null) return;
                _tabata.restTime = restTime;
                _onTabataChanged();
              });
            },
          ),
          ListTile(
            title: Text('Время перерыва'),
            subtitle: Text(formatTime(_tabata.breakTime)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.breakTime,
                    title: Text('Время перерыва'),
                  );
                },
              ).then((breakTime) {
                if (breakTime == null) return;
                _tabata.breakTime = breakTime;
                _onTabataChanged();
              });
            },
          ),
          Divider(height: 10),
          ListTile(
            title: Text(
              'Общее время',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(formatTime(_tabata.getTotalTime())),
            leading: Icon(Icons.timelapse),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutScreen(
                      settings: widget.settings, tabata: _tabata)));
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryTextTheme.button.color,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
