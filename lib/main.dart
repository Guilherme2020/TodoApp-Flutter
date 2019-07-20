import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() => runApp(App());




class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo  App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {

  var itens =  new List<Item>();
  
  HomePage(){
    
    itens = [];
    // itens.add(Item(title: 'Banana',done:false));
    // itens.add(Item(title: 'Abacate',done: true));
    // itens.add(Item(title: 'Banana', done: true));

  }

  @override
  _HomePageState createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {


  var newTaskCtrl = TextEditingController();


  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if(data != null){
      Iterable decoded = jsonDecode(data);

      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();

      setState(() {
        widget.itens = result;
      });

    }
  }
  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data',jsonEncode(widget.itens));
  }
  _HomePageState(){
    load();
  }

  void add(){
    if(newTaskCtrl.text.isEmpty) return;

    setState(() {
      widget.itens.add(
        Item(
          title: newTaskCtrl.text, 
          done: false
        )
      );
      newTaskCtrl.text = "";
      save();
    });
  }
  void remove(int index){
    setState(() {
      widget.itens.removeAt(index);
      save();
    });

  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          keyboardType: TextInputType.text,
          controller: newTaskCtrl,
          style: TextStyle(
            color:Colors.white,
            fontSize: 18,
            
          ),
          decoration: InputDecoration(
            labelText: 'Nova Tarefa',
            labelStyle: TextStyle(color: Colors.white),

          )
        ),
     
      ),
      body: ListView.builder(
        itemCount: widget.itens.length,
        itemBuilder: (BuildContext ctxt, int index){
          final item = widget.itens[index];
          // return Text(widget.itens[index].title);
          // return Text(item.title);
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState((){
                  item.done = value;
                  save();
                });

              },
            ),
              key: Key(item.title),
              background: Container(
                color:Colors.red.withOpacity(0.2),
                child: Text("Excluir"),
              ),
              onDismissed: (direction){
                print(direction);
                remove(index);
              },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}