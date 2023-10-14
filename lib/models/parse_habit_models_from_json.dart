import 'dart:convert';

import 'package:habit_tracker/models/habit.dart';

import '../API/habits_api.dart';

List<Habit> parseModelsFromJson(String jsonString) {
  final parsedJson = json.decode(jsonString);

  final modelsJson = parsedJson['habits'] as List<dynamic>;
  final models = modelsJson.map((modelJson) {
    final habit = Habit.fromJson(modelJson);
    final now = DateTime.now().toUtc().millisecondsSinceEpoch.toInt();

    if (habit.date + 86400000 * habit.frequency <= now) {
      habit.date = now;
      habit.doneDates = [];
      HabitsApi().updateHabit(habit: habit);
    }

    return habit;
  }).toList();

  return models;
}
