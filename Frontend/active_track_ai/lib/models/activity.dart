class Activity {
  final String id;
  final String name;
  final int duration;
  final double calories;
  final String? notes;
  final String? aiAnalysis;
  final DateTime date;

  Activity({
    required this.id,
    required this.name,
    required this.duration,
    required this.calories,
    this.notes,
    this.aiAnalysis,
    required this.date,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      duration: json['duration'],
      calories: (json['calories'] ?? 0).toDouble(),
      notes: json['notes'],
      aiAnalysis: json['aiAnalysis'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
      'notes': notes,
    };
  }
}
