import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/utils/service_locator.dart';

import '../../domain/task_entity.dart';
import '../bloc/task_cubit.dart';

@RoutePage()
class AddTaskScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newTask = Todos(
                  id: DateTime.now().millisecondsSinceEpoch,
                  todo: titleController.text,
                  completed: false,
                  userId: 1, // Replace with actual user ID
                );
                getIt<TaskCubit>().addTask(newTask);
                Navigator.pop(context);
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
