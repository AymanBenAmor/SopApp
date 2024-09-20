
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:essai_banc_compteur_sopal/pages/bridge_between_tests.dart';
import 'dart:developer' as devLog;
import 'package:essai_banc_compteur_sopal/pages/update_info.dart';
import 'indexe.dart' as ind;
import 'information.dart' as INFO;
import 'update_info.dart' as info2;

import 'dart:io';
import 'package:path_provider/path_provider.dart';





int essai = 1;
String titleButton = "Start Essai 2";

bool first_set = true;




List<List<String>> essai_list_1 = [];
List<dynamic> reel_data1 = [];
List<dynamic> info_list1 = [];

List<List<String>> essai_list_2 = [];
List<dynamic> reel_data2 = [];
List<dynamic> info_list2 = [];

List<List<String>> essai_list_3 = [];
List<dynamic> reel_data3 = [];
List<dynamic> info_list3 = [];

List<List<String>> essai_list_4 = [];
List<dynamic> reel_data4 = [];
List<dynamic> info_list4 = [];

List<List<String>> list_aux = [];


class errors extends StatefulWidget {


  @override
  _errors createState() => _errors();
}

class _errors extends State<errors> {

  List<DataRow> dataRows = [];
  FocusNode firstTextFieldFocus = FocusNode();



  List<TextEditingController> textFieldControllers = [];


  List<dynamic> info_list = info2.info_list;

  List<dynamic> reel_data = ind.reel_data;

  List<dynamic> erreurs_final = [];

  List<List<String>> essai_list = ind.test_data;



  @override
  void initState() {
    super.initState();


    if(first_set){
      info_list = INFO.info_list;
      first_set = false;
    }

    list_aux = essai_list;


    switch (essai){
      case 1:
        reel_data1 = reel_data;
        info_list1 = info_list;
        break;
      case 2:
        reel_data2 = reel_data;
        info_list2 = info_list;
        break;
      case 3:
        reel_data3 = reel_data;
        info_list3 = info_list;
        break;
      case 4:
        reel_data4 = reel_data;
        info_list4 = info_list;
        break;
    }



    // Initialize data rows with default index values
    for (int i = 1; i <= 20; i++) {
      TextEditingController controller = TextEditingController();
      textFieldControllers.add(controller);

      if(essai_list[i-1][1] == ''){
        essai_list[i-1][1] = '0';
      }
      if(essai_list[i-1][2] == ''){
        essai_list[i-1][2] = '0';
      }
      if(essai_list[i-1][0] == ''){
        essai_list[i-1][0] = '0';
      }



      int index1 = int.parse(essai_list[i-1][1]);
      int index2 = int.parse(essai_list[i-1][2]);


      erreurs_final.add( ( (index2-index1) ) *1.5 );
      essai_list[i-1].add(erreurs_final[i-1].toString());

      if(essai == 1){
        essai_list_1.add(essai_list[i-1]);

      }else if(essai == 2){
        essai_list_2.add(essai_list[i-1]);

      }else if(essai == 3){
        essai_list_3.add(essai_list[i-1]);

      }else if(essai == 4){
        essai_list_4.add(essai_list[i-1]);

      }



      dataRows.add(DataRow(
        color: MaterialStateColor.resolveWith((states) {
          return (erreurs_final[i-1] > info_list[5] || erreurs_final[i-1] < 0 ) ? Colors.red.withOpacity(0.3) : Colors.transparent;
        }),
          cells: [
            DataCell(Text(i.toString())),
            DataCell(Text(
              essai_list[i-1][0].toString(),
            )),
            DataCell(Text(
              erreurs_final[i-1].toString(),
            )),
          ] // Adjust the row height here
      ));
    }




    String message = "Welcome to the errors page";
    devLog.log(message,name: "welcome");

    devLog.log(essai.toString(),name: "essai");


    devLog.log(essai_list_1.toString(),name: "essai1_list");
    devLog.log(reel_data1.toString(),name: "reel_data1");
    devLog.log(info_list1.toString() + "\n",name: "info_list1");

    devLog.log(essai_list_2.toString(),name: "essai2_list");
    devLog.log(reel_data2.toString(),name: "reel_data2");
    devLog.log(info_list2.toString() + "\n",name: "info_list2");

    devLog.log(essai_list_3.toString(),name: "essai3_list");
    devLog.log(reel_data3.toString(),name: "reel_data3");
    devLog.log(info_list3.toString() + "\n",name: "info_list3");

    devLog.log(essai_list_4.toString(),name: "essai4_list");
    devLog.log(reel_data4.toString(),name: "reel_data4");
    devLog.log(info_list4.toString() + "\n",name: "info_list4");


    //info_list = [op,typcomp,numjauge,volume,debit,err]
    //essai1_list = [[ref,ind1,ind2,err],....]

  }

  void _show_popup_bridge (BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return bridge();
      },
    );
  }



  void start_next_essai() {

    if(essai <= 3){
      essai ++;
      titleButton = "Start Esaai ${essai+1}";
      if(essai==4){
        titleButton = "End Essais";
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext) => UpdateInfoPage()));

    }else{
      essai = 1;
      titleButton = "Start Esaai ${essai+1}";
      essai_list.clear();
      essai_list_1.clear();
      reel_data1.clear();
      info_list1.clear();

      essai_list_2.clear();
      reel_data2.clear();
      info_list2.clear();

      essai_list_3.clear();
      reel_data3.clear();
      info_list3.clear();

      essai_list_4.clear();
      reel_data4.clear();
      info_list4.clear();
      info_list.clear();
      devLog.log("restart app",name: "restart");

      _show_popup_bridge(context);

    }



  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("RESULTAT ESSAI ${essai}"),
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
                  columnSpacing: 40,
                  columns: const <DataColumn>[
                    DataColumn(label: Text('N°')),
                    DataColumn(label: Text('Référence')),
                    DataColumn(label: Text('Erreur')),
                  ],
                  rows: dataRows,
                ),
              ),
            ),

            SizedBox(height: 30,),

            Container(
              child: ElevatedButton(
                onPressed: start_next_essai,
                child: Text(
                  titleButton,
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

    super.dispose();
  }
}


