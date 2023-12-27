import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:http/http.dart' as http;





class secondPage extends StatefulWidget {
    const secondPage({super.key, required this.title});

    final String title;

    @override
    State<secondPage> createState() => _secondPage();

}

class _secondPage extends State<secondPage>{


  // List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

  // String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


  Future<List<Person>> response() async {
    final response =  await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      print(response);

    if(response.statusCode == 200) {

      // List<person> data() => List<person>.from(jsonDecode(response as String).map((x) =>  person.fromJson(x)));
      var data =  jsonDecode(response.body);
      print(data);
      List<Person> persons = data.map<Person>((e) => Person.fromPostJson(e)).toList();
      print(persons);
      return persons;
    } else {
      throw Exception('error');
    }
  }

 // late Future<person> persons;
  late Future persons = response();
  void initialState() {
    super.initState();
   persons = response();

  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body:  Column(
        children: <Widget>[
          FutureBuilder<List<Person>>(
            future: response(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(

                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, index)  {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${snapshot.data![index].id}' )
                        ],
                      );
                    }
                );
                // return Text(snapshot.data!['index'][''] as String);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),

          // ListView.builder(
          //     itemCount: ,
          //     itemBuilder:
          // )


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () => {
                // print(onchanges),
                response(),

              // print(persons)
              },
              child: const Text('submit'),
            ),
          ),
          ]
      ),
    ) );
  }
}

class Person {
  int userId;
  int  id;
  String title;
  String body;

  Person({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
});

  factory Person.fromPostJson(Map<String, dynamic> data) => Person(
      userId: data['userId'],
      id: data['id'],
      title: data['title'],
      body: data['body'],
  );

  // Map<String, dynamic> toPostJson() => {
  //       'userId': userId,
  //       'id': id,
  //       'title': title,
  //       'body': body,
  // };

}
