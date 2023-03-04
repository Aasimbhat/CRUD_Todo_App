import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List items =[];
  @override
  void initState() {
    fetechTodo();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Todo List")),
        backgroundColor: Colors.grey[700],
      ),
      body: RefreshIndicator(
        onRefresh: fetechTodo,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context , index){
            final item=items[index] as Map;
          return ListTile(
            leading: CircleAvatar(child: Text('${index +1}')),
            title: Text(item['title']),
            subtitle: Text(item['description']),
          );
        }
        ),
      ),
       floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Get.to(()=>AddTodoPage());
        },
         label: Text("Add Todo")),
      
    );
  }
  Future<void> fetechTodo() async{
    final url ="https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response=await http.get(uri);
    if(response.statusCode==200){
            final json=jsonDecode(response.body )as Map;
            final result=json["items"] as List;
            setState(() {
              items=result;
            });
    }else{

    }
  
  }
}