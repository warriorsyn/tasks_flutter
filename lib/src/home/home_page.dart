import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _todoList = [];

  final taskController = TextEditingController();
  final descriptionController = TextEditingController();
  final tasktimeController = TextEditingController();

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedIndex;

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();

    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _todoList = json.decode(data);
        print(_todoList);
      });
    });
  }

  void _addTask(Color color) {
    setState(() {
      Map<String, dynamic> task = new Map();
      task["title"] = taskController.text;
      task["description"] = descriptionController.text;
      task["time"] = tasktimeController.text;
      task["status"] = false;

      taskController.text = "";
      descriptionController.text = "";
      tasktimeController.text = "";

      _todoList.add(task);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    color: Color(0xff5a348b),
                    gradient: LinearGradient(
                        colors: [Color(0xff8d70fe), Color(0xff2da9ef)],
                        begin: Alignment.centerRight,
                        end: Alignment(-1.0, -1.0))),
                child: _myHeaderContent(),
              ),
            ),
            Positioned(
              top: 160.0,
              left: 18.0,
              child: Container(
                color: Colors.white,
                width: 380.0,
                height: MediaQuery.of(context).size.height / 1.5,
                child: ListView.builder(
                    itemCount: _todoList.length,
                    itemBuilder: (context, position) {
                      return Dismissible(
                        key: Key(_todoList[position].toString()),
                        background: _myHiddenContainer(Colors.deepPurple),
                        child: _myListContainer(
                            _todoList[position]["title"],
                            _todoList[position]["description"],
                            _todoList[position]["time"],
                            Colors.deepPurple),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            setState(() {
                              _lastRemoved = Map.from(_todoList[position]);
                              _lastRemovedIndex = position;

                              _todoList.removeAt(position);
                              _saveData();

                              final snack = SnackBar(
                                content: Text(
                                    "Tarefa ${_lastRemoved["title"]} removida"),
                                action: SnackBarAction(
                                  label: "Desfazer",
                                  onPressed: () {
                                    setState(() {
                                      _todoList.insert(
                                          _lastRemovedIndex, _lastRemoved);
                                      _saveData();
                                    });
                                  },
                                ),
                                duration: Duration(seconds: 2),
                              );
                              Scaffold.of(context).showSnackBar(snack);
                            });
                          }
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                Color taskcolor;

                return AlertDialog(
                  title: Text("Nova tarefa"),
                  content: Container(
                    height: 250.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: taskController,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Task Title",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            controller: descriptionController,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Sub Task",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new GestureDetector(
                                onTap: () {
                                  taskcolor = Colors.purple;
                                },
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  color: Colors.purple,
                                ),
                              ),
                              new GestureDetector(
                                onTap: () {
                                  taskcolor = Colors.amber;
                                },
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  color: Colors.amber,
                                ),
                              ),
                              new GestureDetector(
                                onTap: () {
                                  taskcolor = Colors.blue;
                                },
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  color: Colors.blue,
                                ),
                              ),
                              new GestureDetector(
                                onTap: () {
                                  taskcolor = Colors.green;
                                },
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: TextField(
                            controller: tasktimeController,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Task Time",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Color(0xff2da9ef),
                      child: Text(
                        "Add",
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _addTask(taskcolor);

                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
        backgroundColor: Color(0xff2da9ef),
        foregroundColor: Color(0xffffffff),
        tooltip: "Increment",
        child: new Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _myListContainer(
      String taskname, String subtask, String taskTime, Color taskColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120.0,
        child: Material(
          color: Colors.white,
          elevation: 14.0,
          shadowColor: Color(0x802196F3),
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 80.0,
                  width: 10.0,
                  color: taskColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: Text(taskname,
                                style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: Text(subtask,
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.blueAccent)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(taskTime,
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black45)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myHiddenContainer(Color taskColor) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: taskColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                icon: Icon(FontAwesomeIcons.solidTrashAlt),
                color: Colors.white,
                onPressed: () {
                  setState(() {});
                }),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(FontAwesomeIcons.edit),
                color: Colors.white,
                onPressed: () {
                  setState(() {});
                }),
          ),
        ],
      ),
    );
  }

  Widget _myHeaderContent() {
    return Align(
      child: ListTile(
        leading: Text('Gerenciador de Tarefas',
            style: TextStyle(fontSize: 30.0, color: Colors.white)),
      ),
    );
  }
}
