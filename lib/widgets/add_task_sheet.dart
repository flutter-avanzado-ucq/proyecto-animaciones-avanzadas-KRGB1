import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider_task/task_provider.dart';
import '../services/notification_service.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _controller = TextEditingController(); // Controla el input del usuario.
  DateTime? _selectedDate; // Fecha seleccionada para vencimiento.

  @override
  void dispose() {
    _controller.dispose(); // Libera recursos del controlador de texto.
    super.dispose();
  }

  void _submit() async {
    final text = _controller.text.trim(); // Elimina espacios en blanco.
    if (text.isNotEmpty) {
      // 1. Agrega la tarea al proveedor de estado.
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).addTask(text, _selectedDate);

      // 2. Envia una notificación inmediata informando que se agregó la tarea.
      await NotificationService.showImmediateNotification(
        title: 'Nueva tarea',
        body: 'Has agregado la tarea: $text',
        payload:
            'Tarea: $text', // Este texto será accesible si se toca la notificación.
      );

      // 3. Si el usuario seleccionó una fecha, programa una notificación futura.
      if (_selectedDate != null) {
        await NotificationService.scheduleNotification(
          title: 'Recordatorio de tarea',
          body: 'No olvides: $text',
          scheduledDate: _selectedDate!,
          payload:
              'Tarea programada: $text para ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
        );
      }

      Navigator.pop(context); // Cierra la hoja inferior.
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked; // Guarda la fecha seleccionada.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          const Text(
            'Agregar nueva tarea',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: _pickDate,
                child: const Text('Seleccionar fecha'),
              ),
              const SizedBox(width: 10),
              if (_selectedDate != null)
                Text(
                  '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: const Text('Agregar tarea'),
          ),
        ],
      ),
    );
  }
}
