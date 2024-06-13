
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bloc_cubit/counter/cubit/counter_cubit.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter App",
        style: TextStyle(color: Colors.blueAccent),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, state) {
            return Text('$state');
          },
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              key: const Key('CounterView_increment_fab'),
              icon: const Icon(Icons.add_circle),
              onPressed: () {
                context.read<CounterCubit>().increment();
              },
            ),
            IconButton(
              key: const Key('CounterView_decrement_fab'),
              icon: const Icon(Icons.remove_circle),
              onPressed: () {
                context.read<CounterCubit>().decrement();
              },
            ),
            IconButton(
              key: const Key('CounterView_multiply_fab'),
              icon: const Icon(Icons.coronavirus_sharp),
              onPressed: () {
                context.read<CounterCubit>().multiply();
              },
            ),
            IconButton(
              key: const Key('CounterView_reset_fab'),
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<CounterCubit>().reset();
              },
            ),
          ],
        ),
      ),
    );
  }
}