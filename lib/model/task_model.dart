import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final bool done;

  @HiveField(2)
  final DateTime dueDate;

  @HiveField(3)
  int? notificationId;

  Task({
    required this.title,
    required this.done,
    required this.dueDate,
    required this.notificationId,
  });
}
