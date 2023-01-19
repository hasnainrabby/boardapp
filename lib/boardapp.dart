import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class BoardApp extends StatefulWidget {

  const BoardApp({Key? key}) : super(key: key);

  @override
  State<BoardApp> createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {

  var firestoreDb = FirebaseFirestore.instance.collection("boardappdatabasecollection#1").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Board"),
      ),
      body: StreamBuilder(
          stream: firestoreDb,
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Text("Loading");
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(snapshot.data!.docs[index]['title']);
              },
            );

                })

            );

      }

  }

