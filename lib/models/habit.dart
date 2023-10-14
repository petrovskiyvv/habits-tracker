class Habit {
  late int color;
  late int count;
  late int date;
  late String description;
  late List<dynamic>doneDates;
  late int frequency;
  late int priority;
  late String title;
  late int type;
  late String uid;
  // late int id;

  Habit(this.color, this.count, this.date, this.description, this.doneDates,
      this.frequency, this.priority, this.title, this.type, this.uid);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['color'] = color;
    json['count'] = count;
    json['date'] = date;
    json['description'] = description;
    json['done_dates'] =doneDates;
    json['frequency'] = frequency;
    json['priority'] = priority;
    json['title'] = title;
    json['type'] = type;
    json['uid'] = uid;
    // json['id'] = id;
    return json;
  }

  Habit.fromJson(Map<String, dynamic> json) {
    color = json['color'] ?? 0;
    count = json['count'];
    date = json['date'];
    description = json['description'];
    doneDates = json['done_dates'];
    frequency = json['frequency'];
    priority = json['priority'];
    title = json['title'];
    type = json['type'];
    uid = json['uid'];
    // id = json['id'];
  }
}
