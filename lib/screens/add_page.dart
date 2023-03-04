import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add Todo")),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: "Title"),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: "Description",
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: () {
            submitData();
          }, child: Text("Submit"))
        ],
      ),
    );
  }

  Future <void> submitData() async{
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title, "description": description, "is_completed": false,

    };
    final url ="https://api.nstack.in/v1/todos";
    final uri=Uri.parse(url);
    final response =await http.post(uri,body:jsonEncode(body),
    headers: {"Content-Type":"application/json"}
    );
    if(response.statusCode==201){
      titleController.text="";
      descriptionController.text="";
          showSuccessMessage("Creation Succcess");

    }else{
      showErrorMessage("Creation Failed");

    }
 
    
  }
  void showSuccessMessage(String message){
    final snackBar=SnackBar(content: Text("Creation Success"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

   void showErrorMessage(String message){
    final snackBar=SnackBar(content: Text("Error"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
