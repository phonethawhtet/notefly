import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notefly/constants.dart';
import 'package:notefly/controller/note_controller.dart';
import 'package:notefly/screen/note_list_screen.dart';

class AppBarScreen extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final AppBarScreenMode mode;
  Function(String)? searchAction;
  VoidCallback? createAction;
  VoidCallback? readAction;
  VoidCallback? updateAction;
  VoidCallback? deleteAction;

  var noteController = Get.put(NoteController());

  AppBarScreen({
    Key? key,
    required this.mode,
    this.searchAction,
    this.createAction,
    this.readAction,
    this.updateAction,
    this.deleteAction,
  })  : preferredSize = const Size.fromHeight(60.0),
        super(key: key);

  buildAction(BuildContext context) {
    switch (mode) {
      case AppBarScreenMode.create:
        return [
          IconButton(
            onPressed: createAction,
            icon: const Icon(
              Icons.save,
              color: Colors.black,
            ),
          ),
        ];
      case AppBarScreenMode.read:
        return [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
            ),
            onPressed: updateAction,
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: deleteAction,
          ),
        ];
      case AppBarScreenMode.update:
        return [
          IconButton(
            onPressed: updateAction,
            icon: const Icon(
              Icons.save_as,
              color: Colors.black,
            ),
          ),
        ];
      case AppBarScreenMode.home:
        return [
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 28,
              color: kBlack,
            ),
            onPressed: () {
              noteController.onSearch.value = true;
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(),
              );
            },
          )
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Notefly',
        style: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: kBlack,
        ),
      ),
      actions: buildAction(context),
      automaticallyImplyLeading: false,
    );
  }
}

class NoteSearchDelegate extends SearchDelegate {
  final noteController = Get.put(NoteController());

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
            noteController.searchNotes.clear();
            noteController.onSearch.value = false;
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
        noteController.searchNotes.clear();
        noteController.onSearch.value = false;
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    noteController.search(query.toLowerCase());
    return NoteListScreen();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    debugPrint('query => $query');
    noteController.search(query.toLowerCase());
    return NoteListScreen();
  }
}
