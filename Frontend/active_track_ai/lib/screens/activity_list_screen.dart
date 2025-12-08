import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../widgets/activity_card.dart';

class ActivityListScreen extends StatefulWidget {
  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  List<Activity> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    // TODO: Load from API
    setState(() {
      _activities = [
        Activity(
          id: '1',
          name: 'Running',
          duration: 45,
          calories: 450,
          date: DateTime.now().subtract(const Duration(hours: 2)),
          aiAnalysis: 'Excellent pace! Consider adding hill sprints.',
        ),
        Activity(
          id: '2',
          name: 'Yoga',
          duration: 60,
          calories: 250,
          date: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        Activity(
          id: '3',
          name: 'Cycling',
          duration: 90,
          calories: 650,
          date: DateTime.now().subtract(const Duration(days: 1)),
          aiAnalysis: 'Great endurance session. Try interval training next time.',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadActivities(),
        child: _activities.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fitness_center, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No activities yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start tracking your fitness journey',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ActivityCard(
                      activity: activity,
                      isExpandable: true,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
