import 'package:flutter/material.dart';
import 'package:habit_tracker/API/habits_api.dart';

import '../models/habit.dart';
import '../widgets/habit_card.dart';
import 'add_update_habit_page.dart';

class HabitsListPage extends StatefulWidget {
  const HabitsListPage({super.key});

  @override
  State<HabitsListPage> createState() => _HabitsListPageState();
}

class _HabitsListPageState extends State<HabitsListPage> {
  late Future<List<Habit>> goodHabits;
  late Future<List<Habit>> badHabits;

  List<Habit> filteredGoodHabits = [];
  List<Habit> filteredBadHabits = [];

  bool isReversed = false;

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showSearchBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Введите текст для поиска',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      isReversed = !isReversed;
                    },
                    icon: const Icon(Icons.sort),
                    label: const Text('Сортировать'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text('Поиск'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    goodHabits = HabitsApi().fetchHabitWithType(type: 0);
    badHabits = HabitsApi().fetchHabitWithType(type: 1);
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = searchController.text;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Привычки'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Хорошие',
                  icon: Icon(Icons.sentiment_very_satisfied),
                ),
                Tab(
                  text: 'Плохие',
                  icon: Icon(Icons.sentiment_very_dissatisfied),
                )
              ],
            )),
        body: TabBarView(
          children: [
            FutureBuilder<List<Habit>>(
              future: goodHabits,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Ошибка при загрузке привычек');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Нет данных для отображения');
                } else {
                  List<Habit> habitsSnapshot = snapshot.data!;
                  filteredGoodHabits = habitsSnapshot
                      .where((habit) => habit.title
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();
                  if (isReversed) {
                    filteredGoodHabits = filteredGoodHabits.reversed.toList();
                  }

                  return ListView.builder(
                      itemCount: filteredGoodHabits.length,
                      itemBuilder: (context, index) {
                        return HabitCard(
                          habit: filteredGoodHabits[index],
                          onPressed: () {
                            HabitsApi().completeHabit(
                                uid: filteredGoodHabits[index].uid);
                          },
                        );
                      });
                }
              },
            ),
            FutureBuilder<List<Habit>>(
              future: badHabits,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Ошибка при загрузке привычек');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Нет данных для отображения');
                } else {
                  List<Habit> habitsSnapshot = snapshot.data!;
                  filteredBadHabits = habitsSnapshot
                      .where((habit) => habit.title
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();
                  if (isReversed) {
                    filteredBadHabits = filteredBadHabits.reversed.toList();
                  }

                  return ListView.builder(
                      itemCount: filteredBadHabits.length,
                      itemBuilder: (context, index) {
                        return HabitCard(
                          habit: filteredBadHabits[index],
                          onPressed: () {
                            HabitsApi().completeHabit(
                                uid: filteredBadHabits[index].uid);
                          },
                        );
                      });
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddUpdateHabitPage(),
            ));
          },
          shape: const CircleBorder(side: BorderSide.none),
          tooltip: 'Добавить привычку',
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 0, 0, 0),
            size: 30.0,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 65,
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  showSearchBottomSheet();
                },
                child: const Icon(Icons.table_rows_rounded),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
