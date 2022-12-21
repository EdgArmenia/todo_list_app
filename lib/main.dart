import 'package:flutter/material.dart';
import 'model/my_provider.dart';
import 'package:provider/provider.dart';
import 'screen/screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.red,
      ),
      title: 'To-Do List',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<MyProvider>.value(value: MyProvider()),
        ],
        child: MainScreen(),
      ),
    );
  }
}
