
import 'package:flutter/material.dart';
import 'package:essai_banc_compteur_sopal/pages/errors.dart';
import 'package:essai_banc_compteur_sopal/pages/waitpopup.dart';

import 'dart:developer' as devLog;
import 'errors.dart' as er;
import 'camera.dart' as cm;

List<List<String>> test_data = [];
List<dynamic> reel_data = [];


class indexe extends StatefulWidget {



  @override
  _indexe createState() => _indexe();
}

class _indexe extends State<indexe> {

  Map<int, String> index1Map = {};

  List<DataRow> dataRows = [];
  FocusNode firstTextFieldFocus = FocusNode();
  FocusNode firstindex2TextFieldFocus = FocusNode();

  int part = 1;


  bool? enable_index1;
  bool? enable_index2;

  List<String> final_index1 = [];
  List<String> final_index2 = [];
  List<String> final_barcode = [];
  List<TextEditingController> textFieldControllers = [];


  String button_title = "Commencer";

  int debit_reel = 0;
  int lecture_de_jauge = 0;
  int lecture_de_temps = 1;
  double debit_reel_value = 0;










  @override
  void initState() {
    super.initState();

    enable_index1 = true;
    enable_index2 = false;

    final_barcode = cm.final_barcode;
    devLog.log(final_barcode.toString(), name: "final_barcode_sent");
    devLog.log(er.list_aux.toString(), name: "essai_list_from_errors");


    // Initialize data rows with default index values
    for (int i = 1; i <= 20; i++) {
      TextEditingController controller = TextEditingController();
      textFieldControllers.add(controller);

      if (er.essai == 1) {
        dataRows.add(DataRow(
            cells: [
              DataCell(Text(i.toString())),

              DataCell(TextField(
                controller: controller,
                enabled: enable_index1,
                focusNode: i == 1 ? firstTextFieldFocus : null,
                keyboardType: TextInputType.number,
                //keyboardType: TextInputType.none,
                onEditingComplete: () {
                  if (i == index1Map.length + 1) {
                    _move_next(controller.text, context);
                  }
                },

              )),
              DataCell(TextField(
                enabled: enable_index2,
              )),
            ] // Adjust the row height here
        ));
      } else {
        dataRows.add(DataRow(
            cells: [
              DataCell(Text(i.toString())),

              DataCell(Text(
                er.list_aux[i - 1][2],
              )),
              DataCell(TextField(
                enabled: enable_index2,
              )),
            ] // Adjust the row height here
        ));
      }
    }


      Future.delayed(Duration(milliseconds: 500), () {
        FocusScope.of(context).requestFocus(firstTextFieldFocus);
      });
    }


  void _move_next(String index1, BuildContext context) async {
    if(index1.isNotEmpty){
      setState(() {
        index1Map[index1Map.length] = index1;
      });


      if (index1Map.length < dataRows.length) {
        await Future.delayed(Duration(milliseconds: 20));
        FocusScope.of(context).nextFocus();
      }else{
        FocusScope.of(context).requestFocus(firstTextFieldFocus);
      }

    }
    if(index1Map.length == 20){
      index1Map.clear();
      FocusScope.of(context).requestFocus(firstTextFieldFocus);
    }

  }

  void _collectValues() {
    if(part == 1){
      if(er.essai > 1){

        button_title = "Calculer l'erreur";
        dataRows.clear();
        textFieldControllers.clear();
        index1Map.clear();
        final_index1.clear();

        FocusScope.of(context).unfocus();


        // Reinitialize data rows with default index values
        for (int i = 1; i <= 20; i++) {
          final_index1.add(er.list_aux[i-1][2]);
          TextEditingController controller = TextEditingController();

          textFieldControllers.add(controller);

          dataRows.add(DataRow(
            cells: [
              DataCell(Text(i.toString())),
              DataCell(Text(

                final_index1[i-1],

              )),
              DataCell(TextField(
                enabled: true,
                focusNode: i == 1 ? firstindex2TextFieldFocus : null,
                keyboardType: TextInputType.number,
                controller: controller, // Set the controller
                onEditingComplete: () {
                  if (i == index1Map.length + 1) {
                    _move_next(controller.text, context);
                  }
                },



              )),
            ],
          ));
        }
      }else{
        final_index1.clear();

          for (TextEditingController controller in textFieldControllers) {

            final_index1.add(controller.text);

          }

          devLog.log(final_index1.toString() + "\n", name: "finalindex1");

          if(final_index1[0] != ''){
            // Clear the existing dataRows
            dataRows.clear();
            textFieldControllers.clear();
            index1Map.clear();

            FocusScope.of(context).unfocus();



            button_title = "Calculer l'erreur";


            // Reinitialize data rows with default index values
            for (int i = 1; i <= 20; i++) {
              TextEditingController controller = TextEditingController();

              textFieldControllers.add(controller);

              dataRows.add(DataRow(
                cells: [
                  DataCell(Text(i.toString())),
                  DataCell(TextField(

                    enabled: false,

                  )),
                  DataCell(TextField(
                    enabled: true,
                    focusNode: i == 1 ? firstindex2TextFieldFocus : null,

                    keyboardType: TextInputType.number,
                    controller: controller, // Set the controller
                    onEditingComplete: () {
                      if (i == index1Map.length + 1) {
                        _move_next(controller.text, context);
                      }
                    },



                  )),
                ],
              ));
            }
          }




      }


        devLog.log(final_index1.toString(),name: "new final_index1");

      if(final_index1[0]!=''){
        part++;
        _showPopupWait(context);
        FocusScope.of(context).requestFocus(firstindex2TextFieldFocus);
      }




    }else{
      final_index2.clear();
      for (TextEditingController controller in textFieldControllers) {
        final_index2.add(controller.text);
      }

      if(final_index2[0] != ''){
        //set up the test1_data
        test_data.clear();

        for(int i=0;i<final_barcode.length;i++){
          List<String> element = [final_barcode[i],final_index1[i],final_index2[i]];
          test_data.add(element);
        }


        //devLog.log(data.toString() + "\n", name: "finalindex1");
        //devLog.log(final_barcode.toString() + "\n", name: "finalbarcode");
        //devLog.log(final_index1.toString() + "\n", name: "finalindex1");
        //devLog.log(final_index2.toString() + "\n", name: "finalindex2");

        devLog.log(test_data.toString() + "\n", name: "test_data");

        //int test = int.parse(final_index1[0]);


        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext) => errors()));
      }


    }
  }

  void _showPopupWait(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WaitPopupPage();
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ESSAI N° ${er.essai}"),
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

            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  dataRowHeight: 35,
                  columnSpacing: 70,
                  columns: const <DataColumn>[
                    DataColumn(label: Text('N°')),
                    DataColumn(label: Text('index1')),
                    DataColumn(label: Text('index2')),
                  ],
                  rows: dataRows,
                ),
              ),
            ),

            SizedBox(height: 30,),

            Container(
              child: ElevatedButton(
                onPressed: _collectValues,
                child: Text(
                  button_title,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstindex2TextFieldFocus.dispose();
    super.dispose();
  }
}






