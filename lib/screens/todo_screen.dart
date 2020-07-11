import 'package:flutter/material.dart';
import 'package:todolistapp/models/todo.dart';
import 'package:todolistapp/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todolistapp/services/todo_service.dart';

import 'home_screen.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoNameController = TextEditingController();
  var _todoDescController = TextEditingController();
  var _todoDateController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  var _selectedCategory;
  var _categories = List<DropdownMenuItem>();

  DateTime _dateTime = DateTime.now();

  _selectedToDoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if(_pickedDate != null) {
      _dateTime = _pickedDate;
      _todoDateController.text = DateFormat('dd-MM-yyyy').format(_pickedDate);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  showSuccessSnackBar(message) {
    var _snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
            color: Colors.purpleAccent
        ),
      ),
      action: SnackBarAction(
          label: 'Hide',
          textColor: Colors.grey,
          onPressed: () {

          }),
      backgroundColor: Colors.black,
    );
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: FlatButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Icon(Icons.home, color: Colors.black,),
          color: Colors.purple,
        ),
        title: Text('Membuat Daftar Kegiatan'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: TextField(
                controller: _todoNameController,
                decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Nama Kegiatan",
                    fillColor: Colors.black54,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.purpleAccent,
                            width: 2.0
                        )
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: TextField(
                controller: _todoDescController,
                decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Description",
                    fillColor: Colors.black54,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.purpleAccent,
                            width: 2.0
                        )
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: TextField(
                controller: _todoDateController,
                decoration: InputDecoration(
                    labelText: "Date",
                    hintText: "22-07-2020",
                    fillColor: Colors.black54,
                    prefixIcon: InkWell(
                      onTap: () {
                        _selectedToDoDate(context);
                      },
                      child: Icon(Icons.date_range),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.purpleAccent,
                            width: 2.0
                        )
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: DropdownButtonFormField(
                value: _selectedCategory,
                items: _categories,
                hint: Text('Category'),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: FlatButton(
                onPressed: () async {
                  var toDoObject = ToDo();

                  toDoObject.name = _todoNameController.text;
                  toDoObject.description = _todoDescController.text;
                  toDoObject.date = _todoDateController.text;
                  toDoObject.isFinished = 0;
                  toDoObject.category = _selectedCategory.toString();

                  var _toDoService = ToDoService();
                  var result = await _toDoService.saveToDo(toDoObject);

                  if(result > 0) {
                    print(result);
                    showSuccessSnackBar('Berhasil Disimpan!');
                  }
                },
                child: Text('Simpan'),
                textColor: Colors.black,
                color: Colors.purpleAccent,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
