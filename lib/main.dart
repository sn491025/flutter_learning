import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodoapp/network_manager.dart';
import 'package:http/http.dart' as http;

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {   
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var onChangeText;
  final OnCreateTask _createTask = OnCreateTask();
  // Future<List<TodoList>> _getTask = OnCreateTask().onGetAllTask();
  bool onCreateNewTaskView = false;
  bool loaderState = false;
  bool updateState = false;
  late var updateTaskId;

  Future onGetAllTodoList() async {
        try {
            final result = await _createTask.onGetAllTask();
            print('$result darta');

            return result;
        } catch(error) {
          print(error);
          return 'error';
        }
  }


  void initialState() {
    super.initState();
    onGetAllTodoList();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Todo App with basic State Management', style: TextStyle(fontSize: 20),),
      ),
      body: Center (
        child: FutureBuilder(
        future: onGetAllTodoList(),
        builder: ( context, snapshot) {
          if(snapshot.data == null || loaderState) {
            return const CircularProgressIndicator();
          } else {
            if (onCreateNewTaskView == true) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Todo',
                        // border: InputBorder()
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty || value == ' ') {
                          return 'todo need';
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        setState(() {
                          onChangeText = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() => loaderState = true);
                          if (updateState) {
                            await _createTask.onUpdateTask(
                                updateTaskId, onChangeText);
                            setState(() =>
                            {
                              onCreateNewTaskView = false,
                              updateState = false,
                              loaderState = false,
                            });
                          } else {
                            await _createTask.createTask(onChangeText);
                            setState(() => {onCreateNewTaskView = false, loaderState = false});
                          }
                        },
                        child: const Text('Submit')
                    ),
                  ),
                ],
              );
            }
            if (onCreateNewTaskView == false) {
              if (snapshot.data!.isNotEmpty) {
                if (!loaderState) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                                leading: Text('${snapshot.data?[index].id}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                title: Text(snapshot.data![index].title,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: TextButton(
                                  onPressed: () async
                                  {
                                    setState(() => loaderState = true);
                                    await OnCreateTask().onTaskDelete(
                                        snapshot.data![index].id);
                                    await OnCreateTask().onGetAllTask();
                                    setState(() => loaderState = false);
                                  },
                                  child: const Text(
                                    'Finished',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                            ),

                            Container(
                              width: 380,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () async =>
                                {
                                  setState(() {

                                    updateTaskId = snapshot.data![index].id;
                                    updateState = true;
                                    onCreateNewTaskView = true;
                                  }),
                                  // await OnCreateTask().onUpdateTask(1, 'update 101')
                                },
                                child: const Text(
                                  'Update',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              } else {
                return const Text('Press Add button to create Task');
              }
            }
          }

          return const CircularProgressIndicator();

        },

      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
          setState(() => onCreateNewTaskView = true);
        //   Navigator.push(
        // context,
        // // MaterialPageRouter(build(context) => const secondPage(title: 'secondScreen'))
        //     MaterialPageRoute(builder: (context) => const secondPage(title: 'sceondScreen'))
        // )

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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