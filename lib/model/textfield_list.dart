import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:todo_list/model/textfield_model.dart';

class TextFieldsList {
  List<TextFieldModel> textFields;

  TextFieldsList({required this.textFields});

  factory TextFieldsList.fromJson(Map<String, dynamic> json) {
    var textFieldsJson = json['textFields'] as List;

    List<TextFieldModel> textFiledsList =
        textFieldsJson.map((i) => TextFieldModel.fromJson(i)).toList();

    return TextFieldsList(
      textFields: textFiledsList,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    List<Map<String, dynamic>> textFieldsList = [];

    for (var i in textFields) {
      textFieldsList.add(i.toJson());
    }

    data['textFields'] = textFieldsList;

    return data;
  }
}

Future<String> get getLocalPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get getLocalFile async {
  final path = await getLocalPath;
  return File('$path/data.json');
}

void writeJson(Future<TextFieldsList> list) async {
  Map<String, dynamic> data = {};
  list.then((value) => data = value.toJson());

  final file = await getLocalFile;
  var value = jsonEncode(data);

  await file.writeAsString(value);
}

Future<TextFieldsList> readJson() async {
  final file = await getLocalFile;
  var value;
  try {
    value = await file.readAsString();
  } catch (_) {
    value = '';
  }

  if (value.isEmpty) {
    value = '{"textFields": [{"pressed": false, "text": ""}]}';
    Map<String, dynamic> map = await jsonDecode(value);
    return TextFieldsList.fromJson(map);
  } else {
    return TextFieldsList.fromJson(jsonDecode(value));
  }
}
