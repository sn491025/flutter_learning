import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodoapp/bloc.dart';
import 'package:fluttertodoapp/blocStateManagement/counter_bloc/counter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => Counter(),
        child:  MyHomePage(title: 'blocStateManagement'),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({super.key, required this.title});

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final cubit = CounterCubit();
  final blocCounter = CounterBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text(
          'Todo App with bloc stateManagement',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: BlocBuilder<Counter, int>(
        builder: (Counter, count) {
          return Center(
            child: Text(
                '$count',
              style: const TextStyle(fontSize: 24.0),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<Counter>().add(BlocCounterIncrementPressed()),
            // {
              // setState(() {
              //
              // });
              // print('${cubit.state} before');
              // cubit.increment();
              // print(cubit.state);
              // cubit.onChange();
              // print(blocCounter.state);
              // blocCounter.add(CounterIncrementPressed());
              // Future.delayed(Duration.zero);
              // print(blocCounter.state);
              // blocCounter.stream.listen(print);
              // blocCounter.add(CounterIncrementPressed());
              // blocCounter
              //         .add(CounterIncrementPressed());

            // },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),

          FloatingActionButton(
              child: const Icon(Icons.remove),
              onPressed: () => context.read<Counter>().add(BlocCounterDecrementPressed()),
          )
        ],
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TodoList {
  int id;
  String title;

  TodoList({required this.id, required this.title});

  factory TodoList.fromTodoListData(Map<String, dynamic> data) => TodoList(
        id: data['id'],
        title: data['title'],
      );
}

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
      print('$error, $stackTrace');
      super.onError(error, stackTrace);
  }

}
