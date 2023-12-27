import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertodoapp/main.dart';
import 'package:http/http.dart' as http;


class OnCreateTask {



  // All Task GET CALL
  Future<List<TodoList>> onGetAllTask() async {

    final response = await http.get(Uri.parse('https://todo-4kyh.onrender.com/'));
    print('${response.body} Get call');
    var data = jsonDecode(response.body);

    if(response.statusCode == 200) {
      List<TodoList> result = data?.map<TodoList>((e) => TodoList?.fromTodoListData(e)).toList();
      return result;
    } else {
      print('todo get call error $data');
      return data;
    }
  }

  //  on Create task POST CALL 
  Future<dynamic> createTask(String taskDescription)  async {

    Map<String, dynamic> formData = {
      'title': taskDescription,
    };
        try {
          var result = await http.post(
            Uri.parse('https://todo-4kyh.onrender.com/'),
            body: formData,
          );
          print('${ result.body} data');
          if(result.statusCode == 200) {
            await onGetAllTask();
            return result.body;
          }
        } catch (error) {
          print('error $error');
        }
  }
  
  // on Update Task POST CALL
  Future<dynamic> onUpdateTask(int taskId, String taskDescription) async {
    try {
      print('$taskId, $taskDescription');
      Map<String, dynamic> data = {
        'title': taskDescription,
      };
      var response = await http.post(
        Uri.parse('https://todo-4kyh.onrender.com/update/$taskId'),
        body: data
      );
      print(response.statusCode);
      if(response.statusCode == 200) {

        await onGetAllTask();
        return response.body;
      }

    } catch(e) {
      print('error $e');
      return '$e';
    }
  }
  



  // Delect task DELETE CALL
  Future<dynamic> onTaskDelete(int taskId) async {
      try {
        // print('$taskId task id');
       var response = await http.delete(
          Uri.parse('https://todo-4kyh.onrender.com/delete/$taskId'),
        );
          if(response.statusCode == 200) {
            await onGetAllTask();
            print('${response.statusCode} response');
          }
      } catch(e) {
        return '$e';
      }
  }

}