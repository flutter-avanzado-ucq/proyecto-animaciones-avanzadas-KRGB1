import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final bool isDone;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Animation<double> iconRotation;
  final DateTime? vencimiento; // Agregado para la fecha de vencimiento

  const TaskCard({
    super.key,
    required this.title,
    required this.isDone,
    required this.onToggle,
    required this.onDelete,
    required this.iconRotation,
    required this.vencimiento, // Agregado para la fecha de vencimiento
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(title), // Usa un identificador único para cada tarea
      direction:
          DismissDirection
              .startToEnd, // Permite deslizar la tarjeta hacia a la derecha
      onDismissed: (direction) {
        onDelete(); //Elimina la tarea al deslizar
      },
      //Se encarga de la visualizacion del fondo al deslizar como la alineacion y el color
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        //Se agrego un color claro con una opacidad de 0.7 para distinguirlo del boton de eliminar
        color: const Color.fromARGB(255, 216, 86, 86).withOpacity(0.7),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        //Se aumento la opacidad a 0.8 para que la tarjeta tenga mas grosor y enfasis
        //Se disminuyo los milisegundos para que fuera mas rapida la animacion
        opacity: isDone ? 0.8 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            //Se cambio el color por un verde mas oscuro para que se distinga mas
            color: isDone ? const Color.fromARGB(255, 7, 90, 10) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            leading: GestureDetector(
              onTap: onToggle,
              child: AnimatedBuilder(
                animation: iconRotation,
                builder: (context, child) {
                  return Transform.rotate(
                    //Se multiplico por 2 * pi para que se haga la
                    //rotacion completa porque se ve mejor
                    angle: isDone ? iconRotation.value * pi : 0,
                    child: Icon(
                      isDone
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isDone ? Colors.green : Colors.grey,
                    ),
                  );
                },
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? Colors.black54 : Colors.black87,
                  ),
                ),

                // Muestra la fecha de vencimiento si está presente
                if (vencimiento != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Vence: ${DateFormat('dd/MM/yyyy').format(vencimiento!)}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ),
        ),
      ),
    );
  }
}
