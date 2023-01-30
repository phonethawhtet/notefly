import 'package:flutter/widgets.dart';

String colorToString(Color color) {
  return color.value.toRadixString(32).padLeft(8, '0').toUpperCase();
}

Color stringToColor(String colorString) {
  var value = int.parse(colorString.substring(1), radix: 32);
  return Color(value);
}
