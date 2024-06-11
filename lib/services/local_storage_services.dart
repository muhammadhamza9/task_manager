import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../features/home/domain/task_entity.dart';

class LocalStorageService {
  static const String _tasksKey = 'tasks';

  Future<void> saveTasks(List<Todos> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    prefs.setString(_tasksKey, jsonEncode(tasksJson));
  }

  Future<List<TaskEntity>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_tasksKey);

    if (tasksJson != null) {
      List tasks = jsonDecode(tasksJson);
      return tasks.map((task) => TaskEntity.fromJson(task)).toList();
    } else {
      return [];
    }
  }
}
