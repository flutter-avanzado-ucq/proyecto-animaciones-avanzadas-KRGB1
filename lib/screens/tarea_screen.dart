import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/card_tarea.dart';
import '../widgets/header.dart';
import '../widgets/add_task_sheet.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _tasks = [];
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _addTask(String task) {
    setState(() {
      _tasks.insert(0, {'title': task, 'done': false});
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
    _iconController.forward(from: 0);
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddTaskSheet(onSubmit: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              //previene que las animaciones se repitan
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    //Define el retardo y posicion
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      //Hace que las tareas
                      //entren deslizandose desde abajo
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        //Hace un efecto de desvanecimiento
                        child: FadeInAnimation(
                          child: TaskCard(
                            title: task['title'],
                            isDone: task['done'],
                            onToggle: () => _toggleComplete(index),
                            onDelete: () => _removeTask(index),
                            iconRotation: _iconController,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: const Color.fromARGB(255, 78, 49, 164),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        //Necesita de un animationController
        child: AnimatedIcon(
          //Se cambio el icono de add por arrow_menu para tener un estilo diferente
          icon: AnimatedIcons.arrow_menu,
          progress: _iconController,
        ),
      ),
    );
  }
}
