import 'package:boardapp/boardapp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();    //initilized Firebase
  runApp(const MaterialApp(
    home: BoardApp() ,
  ));
}





