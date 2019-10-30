import 'package:checklist/exceptions/custom_exceptions.dart';
import 'package:checklist/providers/local_storage_provider.dart';
import 'package:checklist/repositories/auth_repository.dart';
import 'package:checklist/services/auth_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements AuthServices {}

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  final mockService = MockAuthService();
  final mockStorage = MockLocalStorage();
  final repo = AuthRepository(services: mockService, localStorage: mockStorage);

  test('First it should try to signin', () async {
    when(
      mockService.signIn(
        email: anyNamed('email'),
        password: anyNamed(
          'password',
        ),
      ),
    ).thenAnswer((_) => Future.value({'idToken': 'token', 'localId': 'id'}));

    await repo.authenticateAndRetrieveToken(
      email: 'email',
      password: 'password',
    );

    verify(mockService.signIn(email: 'email', password: 'password'));
    verify(mockStorage.saveToken('token'));
    verify(mockStorage.saveUserId('id'));
    verifyNoMoreInteractions(mockService);
  });

  test(
      'In case of wrong (but existing) credentials, it should throw invalid credentials exception',
      () async {
    when(
      mockService.signIn(
        email: anyNamed('email'),
        password: anyNamed(
          'password',
        ),
      ),
    ).thenThrow(InvalidCredentials());

    await expectLater(
        () => repo.authenticateAndRetrieveToken(
            email: 'email', password: 'password'),
        throwsA(predicate((e) => e is InvalidCredentials)));
    verify(mockService.signIn(email: 'email', password: 'password'));
    verifyNoMoreInteractions(mockStorage);
    verifyNoMoreInteractions(mockService);
  });

  test('In case of non existing credentials, it should try to signup',
      () async {
    when(
      mockService.signIn(
        email: anyNamed('email'),
        password: anyNamed(
          'password',
        ),
      ),
    ).thenThrow(UserNotAvailable());

    when(
      mockService.signUp(
        email: anyNamed('email'),
        password: anyNamed(
          'password',
        ),
      ),
    ).thenAnswer((_) => Future.value({'idToken': 'token', 'localId': 'id'}));

    await repo.authenticateAndRetrieveToken(
      email: 'email',
      password: 'password',
    );

    verify(mockService.signIn(email: 'email', password: 'password'));
    verify(mockService.signUp(email: 'email', password: 'password'));
    verify(mockStorage.saveToken('token'));
    verify(mockStorage.saveUserId('id'));
    verifyNoMoreInteractions(mockService);
  });

  test('Save Data', () async {
    await repo.saveUserInfo({'idToken': 'token', 'localId': 'id'});
    verify(mockStorage.saveToken('token'));
    verify(mockStorage.saveUserId('id'));
  });

  test('Retrive token', () async {
    when(mockStorage.getToken()).thenAnswer((_) => Future.value('token'));
    final token = await repo.getToken();
    expect(token, 'token');
    verify(mockStorage.getToken());
  });
}
