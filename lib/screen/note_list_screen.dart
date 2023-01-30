import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notefly/components/note_card.dart';
import 'package:notefly/constants.dart';
import 'package:notefly/controller/note_controller.dart';
import 'package:notefly/model/Note.dart';
import 'appbar_screen.dart';

final box = GetStorage();

class NoteListScreen extends StatelessWidget {
  NoteListScreen({super.key});

  var noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (noteController.onSearch.value) {
            noteController.searchNotes.clear();
            noteController.onSearch.value = false;
            Get.offAllNamed("/", arguments: true);
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: (Get.arguments ?? false) ||
                  (noteController.searchNotes.isEmpty &&
                      !noteController.onSearch.value)
              ? AppBarScreen(
                  mode: AppBarScreenMode.home,
                )
              : null,
          floatingActionButton: noteController.onSearch.value
              ? null
              : FloatingActionButton(
                  backgroundColor:
                      noteController.onNoteSelected ? kRed : kBlack,
                  onPressed: noteController.onNoteSelected
                      ? () => noteController.deleteNotes()
                      : () => Get.toNamed('/createNote'),
                  child: noteController.onNoteSelected
                      ? const Icon(Icons.delete_forever)
                      : const Icon(Icons.add),
                ),
          body: Container(
            color: Colors.grey.shade300,
            child: MasonryGridView.count(
              padding: const EdgeInsets.all(10.0),
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              itemCount: noteController.searchNotes.isEmpty
                  ? noteController.notes.length
                  : noteController.searchNotes.length,
              itemBuilder: (context, index) {
                Note note;
                if (noteController.searchNotes.isEmpty) {
                  note = noteController.notes.reversed.elementAt(index);
                } else {
                  note = noteController.searchNotes.elementAt(index);
                }
                return SizedBox(
                  height:
                      (index % 5 + 1) * 60 > 150 ? 150 : (index % 5 + 2.4) * 60,
                  child: NoteCard(note: note),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
