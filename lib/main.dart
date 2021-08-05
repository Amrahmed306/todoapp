import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/bloc_observer.dart';
import 'layout/home_layout.dart';

void main() {
  runApp(MyApp());
  Bloc.observer = SimpleBlocObserver();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home:HomeLayout(),
      debugShowCheckedModeBanner: false,
    );
  }

}
