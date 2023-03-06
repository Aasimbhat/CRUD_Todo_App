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
  List items = [];
  bool isLoading = true;
  @override
  void initState() {
    fetechTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF73be93),
      appBar: AppBar(
        title: Center(child: Text("Todo List")),
        backgroundColor: Color(0xFF192c49),
      ),
      body: RefreshIndicator(
        onRefresh: fetechTodo,
        child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.all(15),
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return Container(
                height: 100,
                child: Card(
                  color: Color(0xFF192c49),
                  shadowColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Color(0xFF73be93),
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "edit") {
                          Get.to(() => AddTodoPage());
                        } else if (value == "delete") {
                          deleteById(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Icon(
                              Icons.edit_attributes,
                              size: 30,
                            ),
                            value: "Edit",
                          ),
                          PopupMenuItem(
                            child: Icon(
                              Icons.delete,
                              size: 30,
                            ),
                            value: 'delete',
                          )
                        ];
                      },
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color(0xFF192c49),
          onPressed: () {
            Get.to(() => AddTodoPage());
          },
          label: Text(
            "Add Todo",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }

  Future<void> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage("Unable To Delete");
    }
  }

  Future<void> fetechTodo() async {
    setState(() {
      isLoading = true;
    });
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        "Please Type In Something :)",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
