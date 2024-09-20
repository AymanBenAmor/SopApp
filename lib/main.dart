import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:essai_banc_compteur_sopal/pages/errors.dart' as err;
import 'package:essai_banc_compteur_sopal/pages/information.dart';


late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/errorsPage': (context) => err.errors(),
      },
      debugShowCheckedModeBanner: false,
      home: InfoPage(),
    );
  }
}









