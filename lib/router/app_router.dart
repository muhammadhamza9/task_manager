import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../features/authentication/presentation/pages/login_page.dart';
import '../features/home/domain/task_entity.dart';
import '../features/home/presentation/pages/add_task_page.dart';
import '../features/home/presentation/pages/task_details_page.dart';
import '../features/home/presentation/pages/task_list_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: TaskListRoute.page),
        AutoRoute(page: TaskDetailRoute.page),
        AutoRoute(page: AddTaskRoute.page),
      ];
}
