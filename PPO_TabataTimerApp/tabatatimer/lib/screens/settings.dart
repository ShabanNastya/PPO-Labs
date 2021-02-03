import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../models.dart';

/// Names of colours in Colors.primaries
var colorNames = {
  Colors.red: 'Red',
  Colors.pink: 'Pink',
  Colors.purple: 'Purple',
  Colors.deepPurple: 'Deep purple',
  Colors.indigo: 'Indigo',
  Colors.blue: 'Blue',
  Colors.lightBlue: 'Light blue',
  Colors.cyan: 'Cyan',
  Colors.teal: 'Teal',
  Colors.green: 'Green',
  Colors.lightGreen: 'Light green',
  Colors.lime: 'Lime',
  Colors.yellow: 'Yellow',
  Colors.amber: 'Amber',
  Colors.orange: 'Orange',
  Colors.deepOrange: 'Deep orange',
  Colors.brown: 'Brown',
  Colors.blueGrey: 'Blue grey',
};

class SettingsScreen extends StatefulWidget {
  final Settings settings;

  final Function onSettingsChanged;

  SettingsScreen({@required this.settings, @required this.onSettingsChanged});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class AudioSelectListItem extends StatelessWidget {
  final String title;
  final String value;
  final Function(String) onChanged;

  AudioSelectListItem(
      {@required this.title, @required this.onChanged, this.value});

  Widget build(BuildContext context) {
    return ListTile(
      trailing: IconButton(
        icon: Icon(Icons.play_circle_outline),
        onPressed: () {
        },
      ),
      title: Text(title, style: Theme.of(context).textTheme.subtitle2),
      subtitle: DropdownButton<String>(
        isDense: true,
        value: value,
        items: [
        ],
        isExpanded: true,
        onChanged: onChanged,
      ),
    );
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              'Темы',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          SwitchListTile(
            title: Text('Тёмная тема'),
            value: widget.settings.nightMode,
            onChanged: (nightMode) {
              widget.settings.nightMode = nightMode;
              widget.onSettingsChanged();
            },
          ),
          ListTile(
            title: Text('Цветная тема'),
            subtitle: Text(colorNames[widget.settings.primarySwatch]),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        availableColors: Colors.primaries,
                        pickerColor: widget.settings.primarySwatch,
                        onColorChanged: (Color color) {
                          widget.settings.primarySwatch = color;
                          widget.onSettingsChanged();
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
