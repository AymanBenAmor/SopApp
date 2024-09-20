import 'package:flutter/material.dart';
import 'package:essai_banc_compteur_sopal/pages/reel_data_popup.dart';


class WaitPopupPage extends StatelessWidget {

  void _showPopupReel(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyPopupDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white60.withOpacity(0.9),
      title: Text('Attendre...',
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
                _showPopupReel(context); // Close the popup
              },

              style: ElevatedButton.styleFrom(
                  primary: Colors.teal
              ),

              child: Text('Essai terminé !!!',
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
