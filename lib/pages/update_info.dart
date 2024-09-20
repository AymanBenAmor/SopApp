
import 'package:flutter/material.dart';
import 'dart:developer' as devLog;
import 'information.dart' as INFO;
import 'errors.dart' as er;
import 'camera.dart';
import 'indexe.dart';



List<int> num_jauge = [1,2,3,4,5,6,7,8,9,10,11,12];
List<double> debit = [15,22.5,1500,2500,37.5,25,12.5,20,4000,3125,5000,32];
List<int> errors = [1,2,3,4,5,6,7,8,9,10];

List<dynamic> info_list = [];

class UpdateInfoPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<UpdateInfoPage> {

  int? _selectedjauge;
  double? _selecteddebit;
  int? _selectederror;
  bool inputenable = true;

  int volume = 0;


  bool done_jauge = false;
  bool done_debit = false;
  bool done_err = false;

  ScaffoldMessengerState? _scaffoldMessengerState;







  void _end_info() {
    if ( done_err && done_debit  && done_jauge) {
      if(er.essai != 1){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => indexe()),
        );
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => camera()),
        );
      }

      devLog.log(INFO.op_typ.toString(), name: "operator_type_list");

      info_list = [
        INFO.op_typ[0],
        INFO.op_typ[1],
        _selectedjauge,
        volume,
        _selecteddebit,
        _selectederror
      ];


      devLog.log(info_list.toString(), name: "updated_info_list");
    }else{
      _scaffoldMessengerState?.showSnackBar(
        SnackBar(
          content: Text("Veuillez remplir tous les champs avant de continuer."),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("INFO ESSAI N° ${er.essai}"),
        centerTitle: true,
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/water.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.4), // Set your desired opacity level
              BlendMode.srcATop,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Container(
                  margin: EdgeInsets.only(top: 20,bottom: 35,left: 10,right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      width: 1.5,

                    ),
                    borderRadius: BorderRadius.circular(15), // Adjust the corner radius
                  ),
                  padding: EdgeInsets.all(10), // Adjust the padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        padding: EdgeInsets.only(top: 5, ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Opérateur : \t\t ${INFO.op_typ[0]}",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 10,bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Type de compteur :\t ${INFO.op_typ[1]}",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),






                Text("    Numéro de jauge ",
                  style: TextStyle(
                    fontSize: 20,
                  ),),
                Container(
                  color: Colors.white.withOpacity(0.3),
                  margin: EdgeInsets.all(10.0),
                  height: 60,

                  // Dropdown input for jauge
                  child: DropdownButtonFormField<int>( // Specify int type explicitly
                    decoration: InputDecoration(
                      labelText: "Numero de jauge",
                      hintText: "Choisir le num de jauge",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedjauge,
                    items: num_jauge.map((int option) {
                      return DropdownMenuItem<int>( // Specify int type explicitly
                        value: option,
                        child: Text(option.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) { // Use int? type
                      setState(() {
                        _selectedjauge = value;
                        done_jauge = true;

                        if (_selectedjauge != null && _selectedjauge! < 7) {
                          volume = 5;
                        } else {
                          volume = 100;
                        }

                      });
                    },
                  ),
                ),




                Container(

                  padding: EdgeInsets.only(left: 32,bottom: 20 ),
                  height: 80,

                  child: Row(
                    children: [
                      Expanded(
                        child: Text("Volume :",
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.blueGrey
                          ),
                        ),
                      ),

                      SizedBox(width: 40,),

                      Expanded(
                        child: Text("$volume L",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.blueGrey
                          ),
                        ),
                      )
                    ],
                  ),
                ),



                Text("    Débit ",
                  style: TextStyle(
                    fontSize: 20,
                  ),),
                Container(
                  color: Colors.white.withOpacity(0.3),
                  margin: EdgeInsets.all(10.0),

                  height: 60,
                  // Dropdown input for jauge
                  child: DropdownButtonFormField<double>( // Specify int type explicitly
                    decoration: InputDecoration(
                      labelText: "Débit",
                      hintText: "Choisir le débit",
                      border: OutlineInputBorder(),
                    ),
                    value: _selecteddebit,
                    items: debit.map((double option) {
                      return DropdownMenuItem<double>( // Specify int type explicitly
                        value: option,
                        child: Text(option.toString()),
                      );
                    }).toList(),
                    onChanged: (double? value) { // Use int? type
                      setState(() {
                        _selecteddebit = value;
                        done_debit = true;

                      });
                    },
                  ),
                ),


                Text("    Erreur tolérée ",
                  style: TextStyle(
                    fontSize: 20,
                  ),),
                Container(
                  color: Colors.white.withOpacity(0.3),
                  margin: EdgeInsets.all(10.0),

                  height: 60,
                  // Dropdown input for jauge
                  child: DropdownButtonFormField<int>( // Specify int type explicitly
                    decoration: InputDecoration(
                      labelText: "Erreur",
                      hintText: "Choisir l'erreur ",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectederror,
                    items: errors.map((int option) {
                      return DropdownMenuItem<int>( // Specify int type explicitly
                        value: option,
                        child: Text(option.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) { // Use int? type
                      setState(() {
                        _selectederror = value;
                        done_err = true;
                      });
                    },
                  ),
                ),


                Container(
                  padding: EdgeInsets.only(left: 110,right: 110,top: 20,bottom: 200),

                  child: ElevatedButton(

                    onPressed: _end_info,
                    child: Text("Appliquer",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
