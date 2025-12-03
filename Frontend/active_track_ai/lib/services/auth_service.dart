import 'package:active_track_ai/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _baseUrl = 'https://api.activetrack.ai';
  static const String _tokenKey = 'auth_token';

  Future<User?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {'email': email, 'password': password},
      );
      
      final token = response.data['token'];
      await _storage.write(key: _tokenKey, value: token);
      _dio.options.headers['Authorization'] = 'Bearer $token';
      
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    _dio.options.headers.clear();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
}

final authServiceProvider = Provider((ref) => AuthService());
