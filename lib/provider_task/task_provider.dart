import 'package:flutter/material.dart';

class Task {
  String title;
  bool done;
  DateTime? vencimiento; // Agrega la funcion de fecha de vencimiento

  //practica se agrega parametro de fecha
  Task({required this.title, this.done = false, this.vencimiento});

  DateTime? get dueDate => vencimiento;
  set dueDate(DateTime? date) => vencimiento = date;
}

//Es como el set state, cuando se llame desde otro widget se va a actualizar el diseño
class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];

  void addTask(String title, DateTime? fecha, {DateTime? dueDate}) {
    tasks.insert(0, Task(title: title, done: false, vencimiento: fecha));
    notifyListeners();
  }

  void toggleTask(int index) {
    tasks[index].done = !tasks[index].done;
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  // Nueva función para editar la tarea
  void editTask(int index, {String? newTitle, DateTime? newFecha}) {
    if (index < 0 || index >= tasks.length) return;
    if (newTitle != null) {
      tasks[index].title = newTitle;
    }
    if (newFecha != null) {
      tasks[index].vencimiento = newFecha;
    }
    notifyListeners();
  }

  void updateTask(int index, String newTitle, {DateTime? newDate}) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].title = newTitle;
      if (newDate != null) {
        tasks[index].dueDate = newDate;
      }
      notifyListeners();
    }
  }
}
