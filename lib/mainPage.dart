import 'package:flutter/material.dart';
import 'package:merlin/editProfile.dart';
import 'package:merlin/qrScan.dart';
import 'package:sqflite/sqflite.dart';
import 'package:merlin/database.dart';

class mainPage extends StatefulWidget {
  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
    DBProvider.db.getData(1).then((value) => print(value));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 5,
        brightness: Brightness.light,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => editProfile()));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 10, top: 20),
                    child: Image.asset(
                      'assets/Edit-Profile.png',
                      fit: BoxFit.contain,
                      height: 40,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 30),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                ],
              )),
          const Divider(
            height: 5,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.grey,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => qr_Scan()));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Image.asset(
                    'assets/QR-Code.png',
                    fit: BoxFit.contain,
                    height: 40,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    'QR Code',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
