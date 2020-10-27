import 'dart:typed_data';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scan/model/scan_result.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class qr_Scan extends StatefulWidget {
  @override
  _qr_ScanState createState() => _qr_ScanState();
}

class _qr_ScanState extends State<qr_Scan> {
  String qrCodeResult;
  bool useOnce = false;
  Image success = null;
  final player = AudioPlayer();
  Map value;

  Future<String> _scan() async {
    ScanResult codeSanner =
        await BarcodeScanner.scan(options: ScanOptions(useCamera: 0));
    setState(() {
      qrCodeResult = codeSanner.rawContent;
      qrCodeResult.replaceAll('Result:', '');
      value = json.decode(qrCodeResult);
      print(value);
      success = Image.asset('assets/success.gif');
      playAudio();
      return qrCodeResult;
    });
  }

  Future<void> playAudio() async {
    var duration = await player
        .setAsset('assets/audios/success-sound.mp3')
        .then((value) => player.play());
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                (qrCodeResult == null) || (qrCodeResult == "")
                    ? "Please Scan to show some result"
                    : 'Your attendance for' +
                        value['subjects'].toString() +
                        'for lecture from ' +
                        value['from'].toString() +
                        ' to ' +
                        value['to'].toString() +
                        ' is marked successfully',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: success,
          )
        ],
      ),
    );
  }
}
