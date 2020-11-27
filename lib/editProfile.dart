import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'database.dart';
import 'mainPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

const pickerData = ['First Year', 'Second Year', 'Third Year', 'Fourth Year'];

class editProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController your_Name = new TextEditingController();
  TextEditingController college_name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile_no = new TextEditingController();
  TextEditingController department = new TextEditingController();
  //TextEditingController year_picker = new TextEditingController();
  String year_picker = "Select Year";
  TextEditingController division = new TextEditingController();
  TextEditingController roll_no = new TextEditingController();
  TextEditingController colleg_no = new TextEditingController();
  bool updateOnce = false;

  showPicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: pickerData),
        changeToFirst: false,
        textAlign: TextAlign.left,
        textStyle: const TextStyle(color: Colors.blue),
        selectedTextStyle: TextStyle(color: Colors.red),
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            year_picker = picker.getSelectedValues()[0];
          });
        });
    picker.show(_scaffoldKey.currentState);
  }

  TextField getTextField(String text, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
        labelText: text,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[900]),
        ),
      ),
      controller: controller,
      cursorColor: Colors.blue[900],
      selectionWidthStyle: BoxWidthStyle.tight,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (updateOnce == false) {
      DBProvider.db.getData(1).then((value) {
        setState(() {
          your_Name.text = value['student_name'];
          college_name.text = value['college_name'];
          email.text = value['email'];
          mobile_no.text = value['mobile'];
          department.text = value['department'];
          year_picker = value['year'];
          division.text = value['division'];
          roll_no.text = value['roll_number'];
          colleg_no.text = value['college_number'];
        });
      });
      updateOnce = true;
    }
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                  getTextField('Student Name', your_Name),
                  getTextField('College Name', college_name),
                  getTextField('Email Address', email),
                  getTextField('Mobile Number', mobile_no),
                  getTextField('Department', department),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Select Year',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  FlatButton(
                      onPressed: () {
                        showPicker(context);
                      },
                      child: Text(year_picker),
                      textColor: Colors.black,
                      shape: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      padding: EdgeInsets.all(0.0)),
                  getTextField('Division', division),
                  getTextField('Roll Number', roll_no),
                  getTextField('College Number', colleg_no),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 50),
                    child: FlatButton(
                        onPressed: () {
                          Map<String, dynamic> modifyData = {
                            'student_name': your_Name.text,
                            'college_name': college_name.text,
                            'email': email.text,
                            'mobile': mobile_no.text,
                            'department': department.text,
                            'year': year_picker,
                            'division': division.text,
                            'roll_number': roll_no.text,
                            'college_number': colleg_no.text
                          };
                          DBProvider.db.updateData(modifyData).then((value) {
                            Fluttertoast.showToast(
                                msg: "Details Updated",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.grey,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          });
                        },
                        child: Text('Save Details'),
                        textColor: Colors.white,
                        color: Colors.blue[900],
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
