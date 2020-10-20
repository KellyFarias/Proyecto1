import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:municipios/screens/wrapper.dart';


class Proyect extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Wrapper(),

    );
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(Proyect());
}