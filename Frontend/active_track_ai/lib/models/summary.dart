class Summary {
  final double totalCalories;
  final int totalDuration;
  final String aiSummary;

  Summary({
    required this.totalCalories,
    required this.totalDuration,
    required this.aiSummary,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalCalories: (json['totalCalories'] ?? 0).toDouble(),
      totalDuration: json['totalDuration'] ?? 0,
      aiSummary: json['aiSummary'] ?? '',
    );
  }
}
