import 'package:flutter/material.dart';
import 'dart:developer' as devLog;
import 'indexe.dart';

class MyPopupDialog extends StatefulWidget {
  // ... Other properties ...


  @override
  _MyPopupDialogState createState() => _MyPopupDialogState();
}

class _MyPopupDialogState extends State<MyPopupDialog> {

  int _enteredLectureDeJauge = 0;
  int _enteredLectureDeTemps = 1;
  double debit_reel_value = 0;

  FocusNode _lectureDeJaugeFocus = FocusNode();
  FocusNode _lectureDeTempsFocus = FocusNode();

  bool done_lecture_temps = false;
  bool done_lecture_jauge = false;


  void _calculatedebit(){
    setState(() {
      debit_reel_value = _enteredLectureDeJauge*3600/_enteredLectureDeTemps;
      debit_reel_value = double.parse(debit_reel_value.toStringAsFixed(2));
    });

  }

  void _hidepopup(){
    if(done_lecture_temps && done_lecture_jauge){
      Navigator.of(context).pop();

      reel_data = [_enteredLectureDeJauge,_enteredLectureDeTemps,debit_reel_value];
      devLog.log(reel_data.toString(),name: "list_reel_data");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_lectureDeJaugeFocus);
    });
  }
  @override
  void dispose() {
    _lectureDeJaugeFocus.dispose();
    _lectureDeTempsFocus.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Info Réél',
        textAlign: TextAlign.center,
      ),
      content: Container(
        color: Colors.white60.withOpacity(0.9),
        height: 200,
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              focusNode: _lectureDeJaugeFocus,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Lecture de Jauge (L)'),
              onChanged: (value) {
                setState(() {
                  _enteredLectureDeJauge = int.tryParse(value) ?? 0;
                  _calculatedebit();
                  if(value.isNotEmpty){
                    done_lecture_jauge = true;
                  }
                });
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_lectureDeTempsFocus);
              },
            ),
            TextField(
              focusNode: _lectureDeTempsFocus,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Lecture Temps (s)'),
              onChanged: (value) {
                setState(() {
                  _enteredLectureDeTemps = int.tryParse(value) ?? 0;
                  _calculatedebit();
                  if(value.isNotEmpty){
                    done_lecture_temps = true;
                  }

                });
              },
              onEditingComplete: (){
                _hidepopup();
              },
            ),
            SizedBox(height: 30),
            Container(
              child: Row(
                children: [
                  //SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Débit réél :",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  //SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "$debit_reel_value L/h",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[

        TextButton(
          onPressed: _hidepopup,
          child: Text('Valider'),
        ),
      ],
    );
  }
}