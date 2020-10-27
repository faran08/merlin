import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merlin/database.dart';
import 'package:merlin/mainPage.dart';
import 'package:merlin/qrScan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class home_screen extends StatefulWidget {
  @override
  _home_screenState createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  TextEditingController your_Name = new TextEditingController();
  TextEditingController college_name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile_no = new TextEditingController();
  TextEditingController department = new TextEditingController();
  TextEditingController year_picker = new TextEditingController();
  TextEditingController division = new TextEditingController();
  TextEditingController roll_no = new TextEditingController();
  TextEditingController colleg_no = new TextEditingController();
  //DBProvider database;

  _saveOneTimeUse() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('oneTimeUser', true);
  }

  @override
  Widget build(BuildContext context) {
    //WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/merlin.png',
            fit: BoxFit.contain,
            height: 50,
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[50],
          elevation: 5,
          brightness: Brightness.light,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Flexible(
                  child: ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Student Name',
                        labelStyle: TextStyle(color: Colors.blue[900])),
                    controller: your_Name,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'College Name'),
                    controller: college_name,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Email Address'),
                    controller: email,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Mobile Number'),
                    controller: mobile_no,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Department'),
                    controller: department,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Year'),
                    controller: year_picker,
                  ),
                  TextField(
                      decoration: InputDecoration(labelText: 'Division'),
                      controller: division),
                  TextField(
                    decoration: InputDecoration(labelText: 'Roll Number'),
                    controller: roll_no,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'College Number'),
                    controller: colleg_no,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: FlatButton(
                        onPressed: () {
                          Map<String, dynamic> addData = {
                            'student_name': your_Name.text,
                            'college_name': college_name.text,
                            'email': email.text,
                            'mobile': mobile_no.text,
                            'department': department.text,
                            'year': year_picker.text,
                            'division': division.text,
                            'roll_number': roll_no.text,
                            'college_number': colleg_no.text
                          };
                          DBProvider.db.insertData(addData);
                          Navigator.pop(context);
                          _saveOneTimeUse();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => mainPage()));
                        },
                        child: Text('Save Details'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.all(0.0)),
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
