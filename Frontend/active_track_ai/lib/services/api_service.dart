import 'package:active_track_ai/services/auth_service.dart';
import 'package:dio/dio.dart';
import '../models/activity.dart';
import '../models/summary.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.activetrack.ai'));
  final AuthService _authService;

  ApiService(this._authService);

  Future<void> addActivity(Activity activity) async {
    final token = await _authService.getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    
    try {
      await _dio.post('/activity/add', data: activity.toJson());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token expired - handle logout
        await _authService.logout();
        rethrow;
      }
      throw Exception(e.response?.data['message'] ?? 'Failed to add activity');
    }
  }

  Future<List<Activity>> getActivities() async {
    final token = await _authService.getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    
    try {
      final response = await _dio.get('/activity/all');
      return (response.data as List)
          .map((json) => Activity.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch activities');
    }
  }

  Future<Summary> getTodaySummary() async {
    final token = await _authService.getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    
    try {
      final response = await _dio.get('/activity/summary/today');
      return Summary.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch summary');
    }
  }

  Future<Map<String, dynamic>> getAIRecommendations() async {
    final token = await _authService.getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    
    try {
      final response = await _dio.get('/ai/recommendations');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch AI recommendations');
    }
  }
}
