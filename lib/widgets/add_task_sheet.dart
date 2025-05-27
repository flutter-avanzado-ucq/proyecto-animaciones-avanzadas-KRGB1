import 'package:flutter/material.dart';

class AddTaskSheet extends StatefulWidget {
  final Function(String) onSubmit;

  const AddTaskSheet({super.key, required this.onSubmit});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmit(text);
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
