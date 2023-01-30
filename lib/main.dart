import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:notefly/constants.dart';
import 'package:notefly/screen/note_list_screen.dart';
import 'package:notefly/screen/note_screen.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const NoteflyApp());
}

class NoteflyApp extends StatelessWidget {
  const NoteflyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notefly App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: kYellow,
          secondary: Colors.black,
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => NoteListScreen()),
        GetPage(
            name: '/createNote',
            page: () => NoteScreen(mode: NoteScreenMode.create)),
        GetPage(
            name: '/readNote',
            page: () => NoteScreen(mode: NoteScreenMode.read)),
        GetPage(
            name: '/updateNote',
            page: () => NoteScreen(mode: NoteScreenMode.update)),
      ],
    );
  }
}
