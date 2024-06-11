import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../features/authentication/presentation/bloc/auth_cubit.dart';
import '../features/home/presentation/bloc/task_cubit.dart';
import '../router/app_router.dart';
import '../services/local_storage_services.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => LocalStorageService());

  getIt.registerSingleton<AppRouter>(AppRouter());

  getIt.registerSingleton<AuthCubit>(AuthCubit());
  getIt.registerSingleton<TaskCubit>(TaskCubit(
      httpClient: getIt<http.Client>(),
      localStorageService: getIt<LocalStorageService>()));
}
