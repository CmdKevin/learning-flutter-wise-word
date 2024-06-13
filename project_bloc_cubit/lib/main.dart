import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_bloc_cubit/app.dart';
import 'package:project_bloc_cubit/counter_observer.dart';

void main() {
  Bloc.observer = const CounterObserver();
  runApp(const CounterApp());
}
