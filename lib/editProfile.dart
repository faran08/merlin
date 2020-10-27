import 'package:flutter/material.dart';

import 'database.dart';
import 'mainPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class editProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  TextEditingController your_Name = new TextEditingController();
  TextEditingController college_name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile_no = new TextEditingController();
  TextEditingController department = new TextEditingController();
  TextEditingController year_picker = new TextEditingController();
  TextEditingController division = new TextEditingController();
  TextEditingController roll_no = new TextEditingController();
  TextEditingController colleg_no = new TextEditingController();
  bool updateOnce = false;
  @override
  Widget build(BuildContext context) {
    if (updateOnce == false) {
      DBProvider.db.getData(1).then((value) {
        your_Name.text = value['student_name'];
        college_name.text = value['college_name'];
        email.text = value['email'];
        mobile_no.text = value['mobile'];
        department.text = value['department'];
        year_picker.text = value['year'];
        division.text = value['division'];
        roll_no.text = value['roll_number'];
        colleg_no.text = value['college_number'];
      });
      updateOnce = true;
    }
    return Scaffold(
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
                          Map<String, dynamic> modifyData = {
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
