// lib/blocs/task/task_cubit.dart

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../services/local_storage_services.dart';
import '../../domain/task_entity.dart';

class TaskCubit extends Cubit<TaskState> {
  final http.Client httpClient;
  final LocalStorageService localStorageService;

  TaskCubit({required this.httpClient, required this.localStorageService})
      : super(TaskInitial());

  int _currentPage = 0;
  final int _limit = 10;
  TaskEntity? _taskEntity;

  void fetchTasks() async {
    final response = await httpClient.get(
      Uri.parse(
          'https://dummyjson.com/todos?limit=$_limit&skip=${_currentPage * _limit}'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      _taskEntity = TaskEntity.fromJson(json);
      _currentPage++;
      emit(TaskLoaded(_taskEntity!));
      localStorageService.saveTasks(_taskEntity!.todos!);
    } else {
      emit(TaskError('Failed to fetch tasks'));
    }
  }

  void addTask(Todos task) {
    _taskEntity?.todos?.add(task);
    emit(TaskLoaded(_taskEntity!));
    localStorageService.saveTasks(_taskEntity!.todos!);
  }

  void updateTask(Todos updatedTask) {
    final index =
        _taskEntity?.todos?.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1 && index != null) {
      _taskEntity?.todos?[index] = updatedTask;
      emit(TaskLoaded(_taskEntity!));
      localStorageService.saveTasks(_taskEntity!.todos!);
    }
  }

  void deleteTask(int id) {
    _taskEntity?.todos?.removeWhere((task) => task.id == id);
    emit(TaskLoaded(_taskEntity!));
    localStorageService.saveTasks(_taskEntity!.todos!);
  }
}

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoaded extends TaskState {
  final TaskEntity taskEntity;

  TaskLoaded(this.taskEntity);
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}
