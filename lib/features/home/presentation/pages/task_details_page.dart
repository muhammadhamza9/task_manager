import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/features/home/presentation/bloc/task_cubit.dart';

import '../../../../utils/service_locator.dart';
import '../../domain/task_entity.dart';

@RoutePage()
class TaskDetailScreen extends StatelessWidget {
  final Todos task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: task.todo);
    final TextEditingController descriptionController =
        TextEditingController(text: task.userId.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
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
              decoration: const InputDecoration(labelText: 'UserID'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Completed'),
                Checkbox(
                  value: task.completed,
                  onChanged: (bool? value) {
                    task.completed = value;
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedTask = Todos(
                  id: task.id,
                  todo: titleController.text,
                  userId: int.parse(descriptionController.text),
                  completed: task.completed,
                );
                getIt<TaskCubit>().updateTask(updatedTask);
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                getIt<TaskCubit>().deleteTask(task.id!);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
