// lib/screens/login_screen.dart

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/router/app_router.dart';
import 'package:task_manager/utils/service_locator.dart';

import '../bloc/auth_cubit.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController =
      TextEditingController(text: 'emilys');
  final TextEditingController passwordController =
      TextEditingController(text: 'emilyspass');

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            BlocConsumer<AuthCubit, AuthState>(
              bloc: getIt<AuthCubit>(),
              listener: (context, state) {
                if (state is AuthSuccess) {
                  getIt<AppRouter>().replace(const TaskListRoute());
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthInitial || state is AuthFailure) {
                  return ElevatedButton(
                    onPressed: () {
                      getIt<AuthCubit>().login(
                        usernameController.text,
                        passwordController.text,
                      );
                    },
                    child: const Text('Login'),
                  );
                } else if (state is AuthSuccess) {
                  return const CircularProgressIndicator();
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
