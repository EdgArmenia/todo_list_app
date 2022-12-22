import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/model/textfield_list.dart';
import 'package:todo_list/model/textfield_model.dart';

import '../screen/screen.dart';

class MyProvider extends ChangeNotifier {
  late Future<TextFieldsList> textFieldsList;

  static DateFormat dateFormat = DateFormat("dd.MM.yyyy");
  List<MyTextField> _widgetList = [];

  String get timeValue => dateFormat.format(DateTime.now());
  List<MyTextField> get getWidgetList => _widgetList;

  void addTextField(MyProvider state) {
    _widgetList.add(MyTextField(state: state));
    textFieldsList
        .then((value) => value.textFields.add(_widgetList.last.model));
    notifyListeners();
  }

  void removeLastTextField() {
    if (_widgetList.length > 1) {
      _widgetList.removeLast();
      textFieldsList.then((value) => value.textFields.removeLast());
    }

    notifyListeners();
  }

  void removeTextFieldByIndex(int index) {
    _widgetList.removeAt(index);
    textFieldsList.then((value) => value.textFields.removeAt(index));

    notifyListeners();
  }

  // void changeFocus(BuildContext context, int currentField, int nextField) {
  //   _widgetList[currentField].getFocus.unfocus();
  //   writeJson(textFieldsList);

  //   if (_widgetList[currentField] != _widgetList.last) {
  //     FocusScope.of(context).requestFocus(_widgetList[nextField].getFocus);
  //   }
  //   notifyListeners();
  // }

  void setData(TextFieldModel model, int index) {
    _widgetList[index].model = model;
    notifyListeners();
  }
}
