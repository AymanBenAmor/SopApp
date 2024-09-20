import 'package:flutter/material.dart';

import 'package:essai_banc_compteur_sopal/pages/update_info.dart';



class bridge extends StatelessWidget {

  void _navigateToNewPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UpdateInfoPage()), // Replace NewPage with the actual page you want to navigate to
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white60.withOpacity(0.9),
      title: Text('-- Essai terminé -- ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
        ),
      ),
      content: Container(
        height: 80,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () {
                // Handle button press
                Navigator.of(context).pop();
                _navigateToNewPage(context); // Close the popup
              },

              style: ElevatedButton.styleFrom(
                  primary: Colors.teal
              ),

              child: Text('Nouveau Essai !',
                style: TextStyle(
                  fontSize: 25,
                ),),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),

    );
  }
}
