import 'package:flutter/material.dart';

const kBlack = Color(0xFF070706);
const kOrange = Color(0xFFFE9A37);
const kRed = Color(0xFFFF0000);
const kBrown = Color(0xFFDEA44D);
const kYellow = Color(0xFFFECA05);
const kYellowLight = Color(0xFFFFF176);

enum AppBarScreenMode {
  create,
  read,
  update,
  home,
}

enum NoteScreenMode {
  create,
  read,
  update,
}

const primaryTextStyleBlack = TextStyle(
  fontFamily: 'Pyidaungsu',
  fontSize: 24,
  fontWeight: FontWeight.w600,
  overflow: TextOverflow.ellipsis,
  color: kBlack,
);
const secondaryTextStyleBlack = TextStyle(
  fontFamily: 'Pyidaungsu',
  fontSize: 18,
  color: kBlack,
);
const primaryTextStyleGrey = TextStyle(
  fontFamily: 'Pyidaungsu',
  fontSize: 24,
  fontWeight: FontWeight.w600,
  overflow: TextOverflow.ellipsis,
  color: Colors.grey,
);
const secondaryTextStyleGrey = TextStyle(
  fontFamily: 'Pyidaungsu',
  fontSize: 18,
  color: Colors.grey,
);
