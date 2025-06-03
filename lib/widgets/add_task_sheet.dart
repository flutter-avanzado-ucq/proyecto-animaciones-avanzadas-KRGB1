import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tareas/provider_task/task_provider.dart';
import 'package:provider/provider.dart';

class AddTaskSheet extends StatefulWidget {
  final dynamic onSubmit;

  //Eliminar codigo
  //final Function(String) onSubmit;

  //Eliminar la linea required this.onSubmit;

  const AddTaskSheet({super.key, required this.onSubmit});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      //Eliminar codigo
      //widget.onSubmit(text);
      Provider.of<TaskProvider>(context, listen: false).addTask(text, null);
      Navigator.pop(context);
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
          ElevatedButton.icon(
            onPressed: _submit,
            //Se cambio el icono de check por el de edit_note
            // para que se vea mas acorde a la accion de agregar una tarea
            icon: const Icon(Icons.edit_note),
            label: const Text('Agregar tarea'),
          ),
        ],
      ),
    );
  }
}
