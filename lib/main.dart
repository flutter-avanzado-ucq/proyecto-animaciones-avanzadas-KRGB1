// Usuario KRGB1
//Repositorio: https://github.com/flutter-avanzado-ucq/proyecto-animaciones-avanzadas-KRGB1.git
//Fecha de entrega: 02/Junio/2025
import 'package:flutter/material.dart';
import 'screens/tarea_screen.dart';
import 'tema/tema_app.dart';
import 'package:provider/provider.dart';
import 'provider_task/task_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => TaskProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tareas Pro',
      theme: AppTheme.theme,
      home: const TaskScreen(),
    );
  }
}
