import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:developer' as devLog;

import '../main.dart';
import 'indexe.dart';

final List<String> final_barcode = [];

class camera extends StatefulWidget {
  @override
  _camera createState() => _camera();
}

class _camera extends State<camera> {
  late CameraController _controller;
  List<String> scannedBarcodes = [];

  bool isScanning = true;
  int ordre = 0;
  List<DataRow> dataRows = [];
  FocusNode firstTextFieldFocus = FocusNode();
  List<TextEditingController> textFieldControllers = [];

  bool block_scanner = true;


  @override
  void initState() {
    super.initState();

    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("Access was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });

    // Initialize data rows with default index values
    for (int i = 1; i <= 20; i++) {
      TextEditingController controller = TextEditingController();
      textFieldControllers.add(controller);
      dataRows.add(DataRow(
        cells: [
          DataCell(Text(i.toString())),
          DataCell(TextField(
            controller: controller,
            focusNode: i == 1 ? firstTextFieldFocus : null,
            keyboardType: TextInputType.number,
            //keyboardType: TextInputType.none,
            onChanged: (newValue) {
                if(!scannedBarcodes.contains(newValue)){
                  _move_next(newValue, context);
                  block_scanner = false;
                }else{
                  controller.clear();
                }


            },
         )),
        ] // Adjust the row height here
      ));
    }

    Future.delayed(Duration(milliseconds: 500), () {
      FocusScope.of(context).requestFocus(firstTextFieldFocus);
    });
  }

  void _move_next(String barcode, BuildContext context) async {

      setState(() {
        scannedBarcodes.add(barcode);
      });

      if (scannedBarcodes.length < dataRows.length) {
        await Future.delayed(Duration(milliseconds: 20));
        FocusScope.of(context).nextFocus();
      }

  }



  Future<void> _startBarcodeScanning() async {

    while (isScanning) {
      try {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", // Color for the scan button
          "Cancel", // Text for the cancel button
          true, // Show flash icon
          ScanMode.BARCODE, // Scan mode for barcode
        );
        if (barcodeScanRes == '-1') {
          _finishScanning(); // Finish scanning when user cancels
        } else if (!scannedBarcodes.contains(barcodeScanRes)) {
          setState(() {
            scannedBarcodes.add(barcodeScanRes);

            FocusScope.of(context).nextFocus();
          });
          final player = AudioCache();
          player.play('sounds/beep.mp3');

          // Update the corresponding data row with the scanned barcode
          int rowIndex = scannedBarcodes.length - 1;

          dataRows[rowIndex] = DataRow(
            cells: [
              DataCell(Text((rowIndex + 1).toString())),
              DataCell(Text(scannedBarcodes[rowIndex])),
            ],
          );

          await Future.delayed(Duration(milliseconds: 300));
        }
      } catch (e) {
        print("Error scanning barcode: $e");
      }
    }
    while(final_barcode.length<20){
      final_barcode.add('');
    }
  }

  void _Scanning() {
    if(block_scanner){
      setState(() {

        isScanning = true; // Set isScanning to true to start scanning again
        _startBarcodeScanning(); // Start the scanning process
      });
    }

  }

  void _clear() {
    scannedBarcodes.clear();
    final_barcode.clear();
    block_scanner = true;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext) => camera()));
  }

  void _finishScanning() {
    setState(() {
      isScanning = false;
    });
  }

  void move_next_page() {

    if(isScanning){
      final_barcode.clear();

      for (TextEditingController controller in textFieldControllers) {

        final_barcode.add(controller.text);

      }
    }else{
      for(int i=0;i<scannedBarcodes.length;i++){
        final_barcode[i] = scannedBarcodes[i];
      }
    }



    devLog.log(final_barcode.toString() + "\n", name: "final_barcode");
    devLog.log(scannedBarcodes.toString() + "\n", name: "scannedBarcodes");

    if(final_barcode[0] != ""){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => indexe(),
        ),
      );
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner les N° de séries"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 30,),
                ElevatedButton(
                  onPressed: _Scanning,
                  child: Text(
                    "Scanner",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                SizedBox(width: 130,),
                ElevatedButton(
                  onPressed: _clear,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text("Clear"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  dataRowHeight: 35,
                  columnSpacing: 70,
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Index')),
                    DataColumn(label: Text('Barcode Value')),
                  ],
                  rows: dataRows,
                ),
              ),
            ),

            SizedBox(height: 30,),

            Container(
              child: ElevatedButton(
                onPressed: move_next_page,
                child: Text("Prendre les indexes",
              style: TextStyle(
                fontSize: 20,
              ),),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

