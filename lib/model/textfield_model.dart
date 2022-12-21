import 'package:flutter/material.dart';

class TextFieldModel {
  String text;
  bool pressed;
  TextEditingController controller = TextEditingController();
  late Icon icon;
  late TextStyle textStyle;
  late int index;

  TextFieldModel({required this.pressed, required this.text}) {
    _setText();
    changeIcon();
    changeTextStyle();
  }

  factory TextFieldModel.fromJson(Map<String, dynamic> json) {
    return TextFieldModel(
      pressed: json['pressed'] as bool,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};

    data['pressed'] = pressed;
    data['text'] = controller.text;

    return data;
  }

  void changePressed() => pressed = !pressed;

  void _setText() => controller.text = text;

  void changeIcon() {
    if (pressed) {
      icon = const Icon(Icons.check_box, color: Colors.red);
    } else {
      icon = const Icon(Icons.check_box_outline_blank);
    }
  }

  void changeTextStyle() {
    if (pressed) {
      textStyle = const TextStyle(
          fontSize: 18.0, decoration: TextDecoration.lineThrough);
    } else {
      textStyle =
          const TextStyle(fontSize: 18.0, decoration: TextDecoration.none);
    }
  }
}
