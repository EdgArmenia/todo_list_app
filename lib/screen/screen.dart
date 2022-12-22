import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/model/my_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/model/textfield_list.dart';
import 'package:todo_list/model/textfield_model.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MyProvider state = Provider.of<MyProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              IntroWidget(time: state.timeValue),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     IconButton(
              //       icon: const Icon(Icons.add, color: Colors.red),
              //       onPressed: (() {
              //         state.addTextField(state);
              //       }),
              //     ),
              //     IconButton(
              //       icon: const Icon(Icons.remove, color: Colors.red),
              //       onPressed: (() {
              //         state.removeLastTextField();
              //         writeJson(state.textFieldsList);
              //       }),
              //     ),
              //   ],
              // ),
              ListField(state: state),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: (() => state.addTextField(state)),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key, required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.history_edu,
          color: Colors.red,
          size: 100.0,
        ),
        const Text(
          "Дела на день",
          style: TextStyle(
            fontSize: 48.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "Что нужно сделать $time",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class ListField extends StatefulWidget {
  ListField({super.key, required this.state});

  final MyProvider state;

  @override
  State<ListField> createState() => _ListFieldState();
}

class _ListFieldState extends State<ListField> {
  @override
  void initState() {
    super.initState();
    widget.state.textFieldsList = readJson();
    _initWidgetList();
  }

  void _initWidgetList() {
    widget.state.textFieldsList.then((models) {
      for (int i = 0; i < models.textFields.length; i++) {
        setState(() {
          widget.state.getWidgetList.add(MyTextField(state: widget.state));
          widget.state.setData(models.textFields[i], i);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<TextFieldsList>(
        future: widget.state.textFieldsList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.state.getWidgetList.length,
              itemBuilder: ((context, index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Card(
                    margin: const EdgeInsets.all(0),
                    color: Colors.red,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'Удалить ',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                  key: UniqueKey(),
                  child: widget.state.getWidgetList[index],
                  onDismissed: (direction) {
                    widget.state.removeTextFieldByIndex(index);
                    writeJson(widget.state.textFieldsList);
                  },
                );
              }),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text(''));
          }
          return const Center(child: Text(''));
        },
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  MyTextField({super.key, required this.state});

  final MyProvider state;

  final _focus = FocusNode();

  var model = TextFieldModel(
    text: '',
    pressed: false,
  );

  FocusNode get getFocus => _focus;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  // Offset _tapPosition = Offset.zero;
  @override
  void initState() {
    widget.model.index = widget.state.getWidgetList.indexOf(widget);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 32.0),
      child: TextField(
        focusNode: widget._focus,
        cursorColor: Colors.black,
        controller: widget.model.controller,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintMaxLines: 1,
          prefixIcon: IconButton(
            icon: widget.model.icon,
            onPressed: () {
              if (widget.model.controller.text != "") {
                setState(() {
                  widget.model.changePressed();
                  widget.model.changeIcon();
                  widget.model.changeTextStyle();
                  writeJson(widget.state.textFieldsList);
                });
              }
            },
          ),
          hintText: "Напишите что-нибудь",
          border: InputBorder.none,
        ),
        style: widget.model.textStyle,
        onChanged: ((_) => writeJson(widget.state.textFieldsList)),
        onSubmitted: (_) {
          widget._focus.unfocus();
          writeJson(widget.state.textFieldsList);
        },
      ),
    );
  }
}
