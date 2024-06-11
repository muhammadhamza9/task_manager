// lib/screens/task_list_screen.dart

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../router/app_router.dart';
import '../../../../utils/service_locator.dart';
import '../bloc/task_cubit.dart';

@RoutePage()
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => getIt<AppRouter>().push(AddTaskRoute()),
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        bloc: getIt<TaskCubit>(),
        builder: (context, state) {
          if (state is TaskInitial) {
            context.read<TaskCubit>().fetchTasks();
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  getIt<TaskCubit>().fetchTasks();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: state.taskEntity.todos?.length ?? 0,
                itemBuilder: (context, index) {
                  final task = state.taskEntity.todos![index];
                  return ListTile(
                    title: Text(task.todo ?? 'Empty'),
                    subtitle: Text('${task.userId ?? 'Unknown'}'),
                    trailing: Checkbox(
                      value: task.completed,
                      onChanged: (bool? value) {},
                    ),
                    onTap: () =>
                        getIt<AppRouter>().push(TaskDetailRoute(task: task)),
                  );
                },
              ),
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
