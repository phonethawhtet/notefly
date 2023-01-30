import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:notefly/constants.dart';
import 'package:notefly/controller/note_controller.dart';
import '../model/Note.dart';
import '../utils.dart';
import 'appbar_screen.dart';

class NoteScreen extends StatelessWidget {
  final NoteScreenMode mode;
  NoteScreen({
    Key? key,
    required this.mode,
  }) : super(key: key);

  final noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    createNote() {
      if (titleController.text.trim().isNotEmpty) {
        noteController.createNote(
          Note(
            id: const Uuid().v1(),
            title: titleController.text.trim(),
            content: contentController.text.trim(),
            color: colorToString(noteController.noteColor),
            date: DateTime.now(),
          ),
        );
        for (var note in noteController.notes) {
          debugPrint(note.toString());
        }
        Get.back();
      } else {
        Get.snackbar(
          'Note title cannot be empty',
          'Please enter some text before saving or left exit.',
        );
      }
    }

    updateNote() {
      final noteId = noteController.currentNoteId;
      Get.offNamed('/updateNote?id=$noteId');
    }

    updateSaveNote() {
      final noteId = noteController.currentNoteId;
      if (titleController.text.trim().isNotEmpty) {
        noteController.updateNote(
          noteId,
          Note(
            id: const Uuid().v1(),
            title: titleController.text.trim(),
            content: contentController.text.trim(),
            color: colorToString(noteController.noteColor),
            date: DateTime.now(),
          ),
        );
        for (var note in noteController.notes) {
          debugPrint(note.toString());
        }
        Get.back();
      } else {
        Get.snackbar(
          'Note cannot be empty',
          'Please enter some text before saving or left exit.',
        );
      }
    }

    deleteNote() {
      final noteId = noteController.currentNoteId;
      noteController.deleteNote(noteId);
      if (noteController.onSearch.value) noteController.searchNotes.clear();
      Get.back();
    }

    buildAppBar() {
      switch (mode) {
        case NoteScreenMode.create:
          return AppBarScreen(
            mode: AppBarScreenMode.create,
            createAction: createNote,
          );
        case NoteScreenMode.read:
          return AppBarScreen(
            mode: AppBarScreenMode.read,
            updateAction: updateNote,
            deleteAction: deleteNote,
          );
        case NoteScreenMode.update:
          return AppBarScreen(
            mode: AppBarScreenMode.update,
            updateAction: updateSaveNote,
          );
      }
    }

    Future<bool> colorPickerDialog() async {
      return ColorPicker(
        // Use the dialogPickerColor as start color.
        color: noteController.noteColor,
        // Update the dialogPickerColor using the callback.
        onColorChanged: (Color color) {
          noteController.noteColor = color;
          debugPrint("color => ${noteController.noteColor}");
        },
        width: 40,
        height: 40,
        borderRadius: 4,
        spacing: 5,
        runSpacing: 5,
        wheelDiameter: 155,
        heading: Text(
          'Select color',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subheading: Text(
          'Select color shade',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        wheelSubheading: Text(
          'Selected color and its shades',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        showMaterialName: true,
        showColorName: true,
        showColorCode: true,
        copyPasteBehavior: const ColorPickerCopyPasteBehavior(
          longPressMenu: true,
        ),
        materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
        colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
        colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
        pickersEnabled: const <ColorPickerType, bool>{
          ColorPickerType.both: false,
          ColorPickerType.primary: true,
          ColorPickerType.accent: true,
          ColorPickerType.bw: false,
          ColorPickerType.custom: false,
          ColorPickerType.wheel: true,
        },
      ).showPickerDialog(
        context,
        // New in version 3.0.0 custom transitions support.
        transitionBuilder: (BuildContext context, Animation<double> a1,
            Animation<double> a2, Widget widget) {
          final double curvedValue =
              Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        constraints:
            const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
      );
    }

    buildScreen() {
      switch (mode) {
        case NoteScreenMode.create:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Note color, tap to change",
                        style: secondaryTextStyleBlack,
                      ),
                      Obx(
                        () {
                          if (titleController.text.isEmpty) {
                            noteController.noteColor = kYellowLight;
                          }
                          return ColorIndicator(
                            width: 40,
                            height: 40,
                            borderRadius: 50,
                            color: noteController.noteColor,
                            onSelectFocus: false,
                            onSelect: () async {
                              // Store current color before we open the dialog.
                              final Color colorBeforeDialog =
                                  noteController.noteColor;
                              // Wait for the picker to close, if dialog was dismissed,
                              // then restore the color we had before it was opened.
                              if (!(await colorPickerDialog())) {
                                noteController.noteColor = colorBeforeDialog;
                                debugPrint(
                                    "color unchanged => ${noteController.noteColor}");
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    style: primaryTextStyleBlack,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: primaryTextStyleGrey,
                    ),
                  ),
                  TextField(
                    controller: contentController,
                    style: secondaryTextStyleBlack,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type something...',
                      hintStyle: secondaryTextStyleGrey,
                    ),
                    maxLines: 1000,
                  ),
                ],
              ),
            ),
          );
        case NoteScreenMode.read:
          final note = noteController.readNote(Get.parameters['id']!);
          String dateString = DateFormat.yMMMd("en_US").format(note.date);
          titleController.text = note.title;
          contentController.text = note.content;
          return Container(
            color: stringToColor(note.color),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Material(
                        color: stringToColor(note.color),
                        child: TextField(
                          enabled: false,
                          controller: titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: primaryTextStyleBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Material(
                        color: stringToColor(note.color),
                        child: Text(
                          dateString,
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        contentController.text,
                        style: secondaryTextStyleBlack,
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ],
              ),
            ),
          );
        case NoteScreenMode.update:
          final note = noteController.readNote(Get.parameters['id']!);
          titleController.text = note.title;
          contentController.text = note.content;
          noteController.noteColor = stringToColor(note.color);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Note color, tap to change",
                        style: secondaryTextStyleBlack,
                      ),
                      Obx(
                        () => ColorIndicator(
                          width: 40,
                          height: 40,
                          borderRadius: 50,
                          borderColor: kBlack,
                          color: noteController.noteColor,
                          onSelectFocus: false,
                          onSelect: () async {
                            // Store current color before we open the dialog.
                            final Color colorBeforeDialog =
                                noteController.noteColor;
                            // Wait for the picker to close, if dialog was dismissed,
                            // then restore the color we had before it was opened.
                            if (!(await colorPickerDialog())) {
                              noteController.noteColor = colorBeforeDialog;
                              debugPrint(
                                  "color unchanged => ${noteController.noteColor}");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    autofocus: true,
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: primaryTextStyleGrey,
                    ),
                    style: primaryTextStyleBlack,
                  ),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type something...',
                      hintStyle: secondaryTextStyleGrey,
                    ),
                    style: secondaryTextStyleBlack,
                    maxLines: 1000,
                  ),
                ],
              ),
            ),
          );
      }
    }

    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: (mode == NoteScreenMode.create ||
              mode == NoteScreenMode.update)
          ? FloatingActionButton(
              backgroundColor: kBlack,
              onPressed:
                  mode == NoteScreenMode.create ? createNote : updateSaveNote,
              child: mode == NoteScreenMode.create
                  ? const Icon(Icons.done)
                  : const Icon(Icons.done_all),
            )
          : null,
      body: SafeArea(
        child: buildScreen(),
      ),
    );
  }
}
