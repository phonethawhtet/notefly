import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notefly/constants.dart';
import '../model/Note.dart';

final box = GetStorage();

class NoteController extends GetxController {
  final _notes = <Note>[].obs;
  List<Note> searchNotes = <Note>[].obs;
  List<String> notesToDelete = <String>[];
  final _currentNoteId = ''.obs;
  final _noteColor = kYellowLight.obs;
  final onSearch = false.obs;

  String get currentNoteId => _currentNoteId.value;
  set currentNoteId(String currentNoteId) {
    _currentNoteId.value = currentNoteId;
  }

  Color get noteColor => _noteColor.value;
  set noteColor(Color noteColor) {
    _noteColor.value = noteColor;
  }

  List<Note> get notes => _notes;
  set notes(List<Note> notes) {
    _notes.value = notes;
  }

  bool get onNoteSelected => notes.any((note) => note.select.value == true);

  @override
  void onInit() {
    // box.erase();
    String title = "Demo Note 🎈";
    String content = "Wecome to Notefly! 👋";

    List<dynamic> dbNotes = box.read('notes') ?? [];
    final forNyein = jsonEncode({
      "id": "demo",
      "title": title,
      "content": content,
      "color": "03VVVSBM",
      "date": 1675063703931
    });
    if (dbNotes.isEmpty) dbNotes.add(forNyein);
    if (dbNotes.isNotEmpty) {
      notes = dbNotes.map((note) => Note.fromJson(note)).toList();
    }
    ever(_notes, (_) {
      box.write(
          'notes',
          notes.map((note) {
            debugPrint(note.toJson());
            return note.toJson();
          }).toList());
    });
    super.onInit();
  }

  void search(String searchTerm) {
    debugPrint('searchTerm => $searchTerm');
    searchNotes = notes
        .where((note) =>
            (note.title.toLowerCase() == searchTerm) ||
            note.title.toLowerCase().contains(searchTerm))
        .toList();
  }

  void createNote(Note note) {
    notes.add(note);
  }

  Note readNote(String id) {
    final note = notes.firstWhere((note) => note.id == id);
    return note;
  }

  void updateNote(String noteId, Note newNote) {
    final note = readNote(noteId);
    final editedNote = note.copyWith(
      title: newNote.title,
      content: newNote.content,
      color: newNote.color,
      date: newNote.date,
    );
    deleteNote(noteId);
    createNote(editedNote);
  }

  void deleteNote(String noteId) {
    notes.removeWhere((note) => note.id == noteId);
  }

  void deleteNotes() {
    notes.removeWhere((note) => notesToDelete.contains(note.id));
  }
}
