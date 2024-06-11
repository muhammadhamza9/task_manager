// test/auth_cubit_test.dart

import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/features/authentication/presentation/bloc/auth_cubit.dart';

import 'auth_cubit_unit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<http.Client>(onMissingStub: OnMissingStub.returnDefault)
])
void main() {
  group('AuthCubit', () {
    late AuthCubit authCubit;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      authCubit = AuthCubit();
    });

    tearDown(() {
      authCubit.close();
    });

    blocTest<AuthCubit, AuthState>(
      'emits [AuthSuccess] when login is successful',
      build: () {
        when(mockClient.post(Uri.parse('https://dummyjson.com/auth/login'),
                body: anyNamed('body')))
            .thenAnswer((_) async => http.Response(
                  jsonEncode({'token': 'fake_token'}),
                  200,
                ));
        return authCubit;
      },
      act: (cubit) => cubit.login('emilys', 'emilyspass'),
      expect: () => [
        isA<AuthSuccess>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthFailure] when login fails',
      build: () {
        when(mockClient.post(Uri.parse('https://dummyjson.com/auth/login'),
                body: anyNamed('body')))
            .thenAnswer((_) async => http.Response(
                  'Unauthorized',
                  401,
                ));
        return authCubit;
      },
      act: (cubit) => cubit.login('testuser', 'wrongpassword'),
      expect: () => [
        isA<AuthFailure>(),
      ],
    );
  });
}
