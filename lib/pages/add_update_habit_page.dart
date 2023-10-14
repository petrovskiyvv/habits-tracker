import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/API/habits_api.dart';
import 'package:habit_tracker/main.dart';

import '../models/habit.dart';

class AddUpdateHabitPage extends StatefulWidget {
  Habit? habit;

  AddUpdateHabitPage({Key? key, this.habit}) : super(key: key);

  @override
  _AddUpdateHabitPageState createState() => _AddUpdateHabitPageState();
}

class _AddUpdateHabitPageState extends State<AddUpdateHabitPage> {
  final Map<String, int> _priorities = {
    'Низкий': 0,
    'Средний': 1,
    'Высокий': 2
  };
  late int _selectedPriority;

  final Map<String, int> _habitTypes = {'Хорошая': 0, 'Плохая': 1};
  late int _selectedHabitType;

  late TextEditingController _nameHabitController;
  late TextEditingController _descriptionHabitController;
  late TextEditingController _countController;
  late TextEditingController _frequencyController;

  @override
  void initState() {
    super.initState();
    _nameHabitController = TextEditingController(
        text: widget.habit != null ? widget.habit!.title : '');
    _descriptionHabitController = TextEditingController(
        text: widget.habit != null ? widget.habit!.description : '');
    _countController = TextEditingController(
        text: widget.habit != null ? widget.habit!.count.toString() : '');
    _frequencyController = TextEditingController(
        text: widget.habit != null ? widget.habit!.frequency.toString() : '');
    _selectedPriority = widget.habit != null ? widget.habit!.priority : 0;
    _selectedHabitType = widget.habit != null ? widget.habit!.type : 0;
  }

  @override
  void dispose() {
    _nameHabitController.dispose();
    _descriptionHabitController.dispose();
    _countController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool isUpdate = widget.habit != null;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(isUpdate ? 'Редактирование привычки' : 'Добавление привычки'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _nameHabitController,
              decoration: const InputDecoration(
                hintText: 'Введите название привычки',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, дайте название';
                } else if (value.trim() == '') {
                  return 'Название не может состоять только из пробелов';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionHabitController,
              decoration: const InputDecoration(
                hintText: 'Опишите привычку',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Это обязательное поле';
                } else if (value.trim() == '') {
                  return 'Описание не может состоять только из пробелов';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              items: _priorities
                  .map((priorityName, priorityValue) {
                    return MapEntry(
                      priorityName,
                      DropdownMenuItem(
                        value: priorityValue,
                        child: Text(priorityName),
                      ),
                    );
                  })
                  .values
                  .toList(),
              value: _selectedPriority,
              onChanged: (priorityValue) {
                setState(() {
                  _selectedPriority = priorityValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Приоритет',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: _habitTypes
                    .map((habitName, habitValue) => MapEntry(
                          habitName,
                          ListTile(
                            title: Text(habitName),
                            leading: Radio(
                              groupValue: _selectedHabitType,
                              value: habitValue,
                              onChanged: (value) {
                                setState(() {
                                  _selectedHabitType = habitValue;
                                });
                              },
                            ),
                          ),
                        ))
                    .values
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _countController,
              decoration: const InputDecoration(
                labelText: 'Количество выполнений',
                hintText: 'за период',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (String? value) {
                if (value == null || value.isEmpty || value == 0) {
                  return 'Введите число не меньше 1';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _frequencyController,
              decoration: const InputDecoration(
                labelText: 'Периодичность',
                hintText: 'в днях',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (String? value) {
                if (value == null || value.isEmpty || value == 0) {
                  return 'Введите число не меньше 1';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState?.save();
                  var color = 0;
                  var count = int.parse(_countController.text);
                  var date =
                      DateTime.now().toUtc().millisecondsSinceEpoch.toInt();
                  inspect(int.parse(_countController.text));
                  var description = _descriptionHabitController.text.toString();
                  var doneDates = [];
                  var frequency = int.parse(_frequencyController.text);
                  var priority = _selectedPriority;
                  var title = _nameHabitController.text;
                  var type = _selectedHabitType;
                  var uid =
                      widget.habit != null ? widget.habit!.uid.toString() : '';

                  Habit newHabit = Habit(color, count, date, description,
                      doneDates, frequency, priority, title, type, uid);

                  if (isUpdate) {
                    widget.habit = newHabit;
                    HabitsApi().updateHabit(habit: newHabit);
                  } else {
                    HabitsApi().addHabit(habit: newHabit);
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                }
              },
              child: Text(isUpdate ? 'Обновить' : 'Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}
