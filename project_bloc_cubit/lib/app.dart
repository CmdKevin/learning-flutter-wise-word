import 'package:flutter/material.dart';
import 'package:project_bloc_cubit/counter/view/counter_page.dart';

class CounterApp extends MaterialApp{
  const CounterApp({super.key}) 
    : super(
        home: const CounterPage(),
    );
}