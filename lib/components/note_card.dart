import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notefly/constants.dart';
import 'package:notefly/controller/note_controller.dart';
import '../model/Note.dart';
import '../utils.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  NoteCard({
    Key? key,
    required this.note,
  }) : super(key: key);

  final noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    String dateString = DateFormat.yMMMd("en_US").format(note.date);

    return Obx(
      () => GestureDetector(
        onTap: () {
          if (!noteController.onNoteSelected) {
            noteController.currentNoteId = note.id;
            Get.toNamed('/readNote?id=${note.id}');
          } else if (noteController.onNoteSelected) {
            note.select.value = !note.select.value;
            if (noteController.notesToDelete.contains(note.id)) {
              noteController.notesToDelete.remove(note.id);
            } else {
              noteController.notesToDelete.add(note.id);
            }
          }
        },
        onLongPress: noteController.onSearch.value
            ? () {}
            : () {
                note.select.value = true;
                noteController.notesToDelete.add(note.id);
              },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: note.select.value ? kRed : Colors.transparent,
                    width: 3,
                  ),
                ),
                elevation: 1,
                color: stringToColor(note.color),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: 'Pyidaungsu',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            color: kBlack,
                          ),
                        ),
                      ),
                      Text(
                        dateString,
                        style: const TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            note.select.value
                ? const Positioned(
                    top: -8,
                    right: -8,
                    width: 30,
                    height: 30,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.delete_forever,
                          size: 20, color: Colors.white),
                    ),
                  )
                : const Positioned(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
