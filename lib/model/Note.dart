import 'dart:convert';
import 'package:get/get.dart';

class Note extends GetxController {
  final String id;
  final String title;
  final String content;
  final String color;
  final DateTime date;
  var select = false.obs;

  Note({
    required this.id,
    required this.title,
    this.color = "",
    this.content = "",
    required this.date,
  });

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, color: $color, date: $date, select: $select)';
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? color,
    DateTime? date,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      color: map['color'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);
}
