import 'dart:convert';
import 'dart:developer';
import 'package:env_flutter/env_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/habit.dart';
import '../models/parse_habit_models_from_json.dart';
import '../utilities/constants.dart';

class HabitsApi {
  Future<List<Habit>> fetchHabitWithType({required int type}) async {
    try {
      var queryParameters = {
        'offset': 0,
        'order_by': 'date',
        'order_direction': 'asc',
        'type': type,
      }.map((key, value) => MapEntry(key, value.toString()));
      final dbDtappToken = dotenv.env['DB_DTAPP_TOKEN'].toString();

      final uri = Uri.https(
        Constants.HABITS_BASE_URL_DOMAIN,
        Constants.HABITS_DATA_PATH,
        queryParameters,
      );
      log('request: ${uri.toString()}');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': dbDtappToken,
        },
      );
      if (response.statusCode == 200) {
        final listHabits = parseModelsFromJson(utf8.decode(response.bodyBytes));
        return listHabits;
      } else {
        throw Exception('Error response');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  void completeHabit({required String uid}) async {
    try {
      String dbDtappToken = dotenv.env['DB_DTAPP_TOKEN'].toString();

      var uri = Uri.https(Constants.HABITS_BASE_URL_DOMAIN,
          '${Constants.HABITS_DATA_PATH}/$uid/complete');
      log('request: ${uri.toString()}');

      final body = json.encode(
          {'date': DateTime.now().toUtc().millisecondsSinceEpoch.toInt()});

      await http.post(uri,
          headers: {
            'Accept': 'application/json',
            'Authorization': dbDtappToken,
            'Content-Type': 'application/json'
          },
          body: body);
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  void addHabit({required Habit habit}) async {
    try {
      String dbDtappToken = dotenv.env['DB_DTAPP_TOKEN'].toString();

      var uri = Uri.https(
          Constants.HABITS_BASE_URL_DOMAIN, Constants.HABITS_DATA_PATH);
      log('request: ${uri.toString()}');

      final body = json.encode(habit.toJson());

      var response = await http.post(uri,
          headers: {
            'Accept': 'application/json',
            'Authorization': dbDtappToken,
            'Content-Type': 'application/json'
          },
          body: body);

      if (response.statusCode == 200) {}
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  void updateHabit({required Habit habit}) async {
    try {
      String dbDtappToken = dotenv.env['DB_DTAPP_TOKEN'].toString();

      var uri = Uri.https(
        Constants.HABITS_BASE_URL_DOMAIN,
        '${Constants.HABITS_DATA_PATH}/${habit.uid}',
      );
      log('request: ${uri.toString()}');

      final body = json.encode(habit.toJson());

      var response = await http.patch(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': dbDtappToken,
          'Content-Type': 'application/json',
        },
        body: body,
      );

      inspect(response.body);

      if (response.statusCode == 200) {
        // Success
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
