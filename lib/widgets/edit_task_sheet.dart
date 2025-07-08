import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider_task/task_provider.dart';
import '../services/notification_service.dart';

// Importar AppLocalizations generado
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTaskSheet extends StatefulWidget {
  final int index;

  const EditTaskSheet({super.key, required this.index});

  @override
  State<EditTaskSheet> createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  late TextEditingController _controller;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    final task =
        Provider.of<TaskProvider>(context, listen: false).tasks[widget.index];
    _controller = TextEditingController(text: task.title);
    _selectedDate =
        task.dueDate; // practica: se carga la FECHA y HORA actuales de la notificación

    if (task.dueDate != null) {
      _selectedTime = TimeOfDay.fromDateTime(task.dueDate!);
    } else {
      _selectedTime = const TimeOfDay(hour: 8, minute: 0);
    }
  }

  void _submit() async {
    final newTitle = _controller.text.trim();
    final localizations = AppLocalizations.of(context)!;
    if (newTitle.isNotEmpty) {
      int? notificationId;
      DateTime? finalDueDate;

      final task =
          Provider.of<TaskProvider>(context, listen: false).tasks[widget.index];

      if (task.notificationId != null) {
        await NotificationService.cancelNotification(task.notificationId!);
      }

      await NotificationService.showImmediateNotification(
        title: localizations.taskUpdated,
        body: localizations.taskUpdatedMsg(newTitle),
        payload: localizations.updatedTaskPayload(newTitle),
      );
      if (!mounted) return;
      Navigator.pop(context);

      if (_selectedDate != null && _selectedTime != null) {
        finalDueDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        notificationId = DateTime.now().millisecondsSinceEpoch.remainder(
          100000,
        );

        await NotificationService.scheduleNotification(
          title: localizations.updatedTaskReminder,
          body: localizations.doNotForget(newTitle),
          scheduledDate: finalDueDate,
          payload: localizations.updatedTaskPayloadWithDate(
            newTitle,
            finalDueDate.toString(),
          ),
          notificationId: notificationId,
        );
      }

      Provider.of<TaskProvider>(context, listen: false).updateTask(
        widget.index,
        newTitle,
        newDate: finalDueDate ?? _selectedDate,
        notificationId: notificationId,
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizations.editTaskTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: localizations.titleLabel,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: _pickDate,
                child: Text(localizations.changeDate),
              ),
              const SizedBox(width: 10),
              if (_selectedDate != null)
                Text(
                  '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: _pickTime,
                child: Text(localizations.changeTime),
              ),
              const SizedBox(width: 10),
              Text(localizations.timeLabel),
              if (_selectedTime != null)
                Text(
                  '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: Text(localizations.saveChanges),
          ),
        ],
      ),
    );
  }
}
