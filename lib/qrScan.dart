import 'dart:typed_data';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scan/model/scan_result.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:merlin/mainPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'ad_manager.dart';
import 'database.dart';
import 'globals.dart' as globals;

class qr_Scan extends StatefulWidget {
  @override
  _qr_ScanState createState() => _qr_ScanState();
}

class _qr_ScanState extends State<qr_Scan> {
  @override
  void initState() {
    // MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    //   nonPersonalizedAds: true,
    //   testDevices: <String>["A2F50D4E1787101D621A9CCE48639DE3"],
    // );

    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.smartBanner,
    );

    //  TODO: Load a Banner Ad
    _loadBannerAd();
  }

  BannerAd _bannerAd;
  // RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("A2F50D4E1787101D621A9CCE48639DE3")

  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(
      appId: AdManager.appId,
    );
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  void dispose() {
    // TODO: Dispose BannerAd object
    _bannerAd?.dispose();
    super.dispose();
  }

  String qrCodeResult;
  bool useOnce = false;
  Image success = null;
  final player = AudioPlayer();
  Map qrJSON;
  bool expiredorNot = false;

  Future<String> _scan() async {
    ScanResult codeSanner =
        await BarcodeScanner.scan(options: ScanOptions(useCamera: 0));
    setState(() {
      qrCodeResult = codeSanner.rawContent;
      qrCodeResult.replaceAll('Result:', '');
      qrJSON = json.decode(qrCodeResult);
      print(qrJSON);
      // if( qrCodeResult['expiryDate'])
      //print(qrJSON['expiryDate']['year']);
      String dateConversion = qrJSON['expiryDateTime'];

      if (DateTime.parse(dateConversion).isBefore(DateTime.now())) {
        Fluttertoast.showToast(
            msg:
                "QR code has expired, please ask your teacher to reissue new QR code",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 16.0);
        expiredorNot = true;
      } else {
        playAudio();
        success = Image.asset('assets/success.gif');
        getDatabase().then((value) {
          print('into getDatabase()');
          sendData(value, qrJSON).then((value) {
            print('Network Request Response');
            print(value.body);
            if (value.statusCode == 200) {
              // Fluttertoast.showToast(
              //     msg: "Connection Established ",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 3,
              //     backgroundColor: Colors.grey,
              //     textColor: Colors.black,
              //     fontSize: 16.0);
              print('Status code 200');
            } else {
              Fluttertoast.showToast(
                  msg: "Upload Error",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.grey,
                  textColor: Colors.black,
                  fontSize: 16.0);
            }
          });
        });
      }

      return qrCodeResult;
    });
  }

  Future<void> playAudio() async {
    var duration = await player
        .setAsset('assets/audios/success-sound.mp3')
        .then((value) => player.play());
  }

  Future<http.Response> sendData(
      Map<String, dynamic> input, Map<String, dynamic> qrJSON) {
    String date = qrJSON['expiryDateTime'];
    DateTime jsonDate = DateTime.parse(date);
    //"2020-11-05 12:12:12"
    String outputDate = jsonDate.year.toString() +
        '-' +
        jsonDate.month.toString() +
        '-' +
        jsonDate.day.toString() +
        ' ' +
        jsonDate.hour.toString() +
        ':' +
        jsonDate.minute.toString() +
        ':' +
        jsonDate.second.toString();

    print(jsonEncode(<String, Object>{
      "subjectId": qrJSON['subjectId'],
      'studentName': input['student_name'],
      'studentEmail': input['email'],
      'mobileNumber': input['mobile'],
      'latitude': globals.lattitude,
      'longitude': globals.longitude,
      'year': input['year'],
      "department": input['department'],
      "division": input['division'],
      "rollNumber": input['roll_number'],
      "scanTime": DateTime.now().toString(),
      'expiryDateTime': outputDate,
    }));

    return http.post(
      'http://vancotech.com/attendance/api/post-scan.php',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        "subjectId": qrJSON['subjectId'],
        'studentName': input['student_name'],
        'studentEmail': input['email'],
        'mobileNumber': input['mobile'],
        'latitude': globals.lattitude,
        'longitude': globals.longitude,
        'year': input['year'],
        "department": input['department'],
        "division": input['division'],
        "rollNumber": input['roll_number'],
        "scanTime": DateTime.now().toString(),
        'expiryDateTime': outputDate,
      }),
    );
  }

  Future<Map<String, dynamic>> getDatabase() async {
    Map<String, dynamic> data;
    await DBProvider.db.getData(1).then((value) {
      data = value;
    });
    return data;
  }

  Text getAppropText(String qrCodeResult, bool expiredorNot) {
    if ((qrCodeResult == null) || (qrCodeResult == "")) {
      return Text(
        "Please Scan to show some result",
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
      );
    } else if (expiredorNot == false) {
      return Text(
          'Your attendance for ' +
              qrJSON['subjectName'].toString() +
              ', lecture' +
              // ' from ' +
              // qrJSON['from'].toString() +
              // ' to ' +
              // qrJSON['to'].toString() +
              ' is marked successfully',
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal));
    } else if (expiredorNot == true) {
      return Text(
        "QR code has expired, please ask your teacher to reissue new QR code",
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (useOnce == false) {
      _scan().then((value) {
        print(value);
        useOnce = true;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        title: Text(
          'QR - Scan',
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: getAppropText(qrCodeResult, expiredorNot),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: (!expiredorNot) ? success : null,
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, left: 20, right: 20),
            child: FlatButton(
                onPressed: () {
                  dispose();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => mainPage()));
                },
                child: Text('Okay'),
                textColor: Colors.white,
                color: Colors.blue[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.only(left: 0, right: 0)),
          )
        ],
      ),
    );
  }
}
