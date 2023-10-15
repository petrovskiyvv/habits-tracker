import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../pages/add_update_habit_page.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final VoidCallback onPressed;

  const HabitCard({super.key, required this.habit, required this.onPressed});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  void _increaseDoneDates() {
    late String textContent;
    widget.habit.doneDates.length++;
    int differenceCount = widget.habit.count - widget.habit.doneDates.length;
    setState(() {
      if (widget.habit.type == 1) {
        textContent = differenceCount > 0
            ? 'Можете выполнить еще $differenceCount'
            : 'Хватит это делать!';
      } else {
        textContent = differenceCount > 0
            ? 'Стоит выполнить еще $differenceCount'
            : 'You are breathtaking!';
      }
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              textContent,
              textAlign: TextAlign.center,
            ),
            duration: const Duration(microseconds: 1000000),
            shape: const StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });
    // Вызов переданного onPressed
    widget.onPressed();
  }

  String getPriorityText() {
    if (widget.habit.priority == 2) {
      return 'Приоритет: высокий';
    } else if (widget.habit.priority == 1) {
      return 'Приоритет: средний';
    } else {
      return 'Приоритет: низкий';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.habit.title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUpdateHabitPage(
                habit: widget.habit,
              ),
            ),
          );
        },
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.habit.description),
            const SizedBox(height: 4),
            Text(getPriorityText()),
            const SizedBox(height: 2),
            Text('Периодичность: ${widget.habit.frequency}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: _increaseDoneDates,
          child: Text('Выполнить '
              '${widget.habit.count}/${widget.habit.doneDates.length}'),
        ),
      ),
    );
  }
}
