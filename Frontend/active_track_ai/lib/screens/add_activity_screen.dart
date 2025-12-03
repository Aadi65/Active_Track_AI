import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';
import '../models/activity.dart';
import '../widgets/custom_button.dart';

class AddActivityScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddActivityScreen> createState() =>
      _AddActivityScreenState();
}

class _AddActivityScreenState extends ConsumerState<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> _activities = [
    'Running',
    'Walking',
    'Cycling',
    'Yoga',
    'Swimming',
    'Weight Training',
    'HIIT'
  ];

  String? _selectedActivity;
  bool _isLoading = false;
  String? _aiAnalysis;
  double? _caloriesBurned;

  void _onSubmitActivity() {
    _submitActivity();
  }

  Future<void> _submitActivity() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final activity = Activity(
        id: '',
        name: _selectedActivity ?? 'Custom Activity',
        duration: int.parse(_durationController.text),
        calories: 0,
        date: DateTime.now(),
        notes: _notesController.text.isEmpty
            ? null
            : _notesController.text,
      );

      final apiService = ref.read(apiProvider);
      await apiService.addActivity(activity);

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _caloriesBurned = 350 + (activity.duration * 8.0);
        _aiAnalysis =
            'Great workout! ${activity.duration} minutes of ${activity.name} burned ${_caloriesBurned!.toInt()} calories. Consider adding intervals next time for better results!';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${activity.name} logged successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save activity: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                if (_isLoading) return;
                _onSubmitActivity();
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Activity'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Activity type
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedActivity,
                      decoration: const InputDecoration(
                        labelText: 'Activity Type *',
                        prefixIcon: Icon(Icons.fitness_center),
                        border: InputBorder.none,
                      ),
                      items: _activities.map((activity) {
                        return DropdownMenuItem(
                          value: activity,
                          child: Row(
                            children: [
                              Icon(_getActivityIcon(activity), size: 20),
                              const SizedBox(width: 12),
                              Text(activity),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedActivity = value),
                      validator: (value) =>
                          value == null ? 'Select an activity' : null,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Duration
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Duration (minutes) *',
                        prefixIcon: Icon(Icons.timer),
                        suffixText: 'min',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter duration';
                        }
                        final num = int.tryParse(value);
                        if (num == null || num <= 0) {
                          return 'Enter valid duration';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Notes
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Notes (optional)',
                        prefixIcon: Icon(Icons.notes),
                        border: InputBorder.none,
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit button
                  CustomButton(
                    text: 'Log Activity',
                    icon: Icons.fitness_center,
                    isLoading: _isLoading,
                    onPressed: () {
                      if (_isLoading) return;
                      _onSubmitActivity();
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getActivityIcon(String activity) {
    switch (activity.toLowerCase()) {
      case 'running':
        return Icons.directions_run;
      case 'cycling':
        return Icons.directions_bike;
      case 'yoga':
        return Icons.self_improvement;
      case 'walking':
        return Icons.directions_walk;
      case 'swimming':
        return Icons.pool;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
