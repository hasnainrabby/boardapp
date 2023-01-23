import 'package:boardapp/ui/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BoardApp extends StatefulWidget {

  const BoardApp({Key? key}) : super(key: key);

  @override
  State<BoardApp> createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var firestoreDb = FirebaseFirestore.instance.collection("boardappdatabasecollection#1").snapshots(); //access data from firestore
  late TextEditingController nameInputController;
  late TextEditingController titleInputController;
  late TextEditingController descriptionInputController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameInputController = TextEditingController();
    titleInputController = TextEditingController();
    descriptionInputController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Board"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
       _showDialog(context);
      },
      child: Icon(Icons.add_box_sharp),),
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
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomCard(snapshot: snapshot.requireData, index: index);
               // return CustomCard(snapshot:snapshot.data, index: index);
               // return Text(snapshot.data!.docs[index]['title']);  //showing data on apps
              },
            );

                })

            );

      }

   _showDialog(BuildContext context) async {
    await showDialog(context: context,
      builder: (BuildContext context) {

      return AlertDialog(
        contentPadding: EdgeInsets.all(10),
        content: Column(
          children: [
            Text("Please fill out the Form."),
            Expanded(
                child: TextField(
              autofocus: true,
              autocorrect: true,
              decoration: InputDecoration(
                label: Text("Your Name*")
              ),
              controller: nameInputController,
            )),
            Expanded(
                child: TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration: InputDecoration(
                      label: Text("Title*")
                  ),
                  controller: titleInputController,
                )),
            Expanded(
                child: TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration: InputDecoration(
                      label: Text("description*")
                  ),
                  controller: descriptionInputController,
                ))
          ],
        ),
        actions: [
          TextButton(onPressed:() {
            nameInputController.clear();
            titleInputController.clear();
            descriptionInputController.clear();
            
            Navigator.pop(context);
          }, 
              child:Text("Cancel")),
          //save data on firestore from app
          TextButton(onPressed: (){
            if(nameInputController.text.isNotEmpty &&
            titleInputController.text.isNotEmpty &&
            descriptionInputController.text.isNotEmpty){
              FirebaseFirestore.instance.collection("boardappdatabasecollection#1")
                  .add({
                "name" : nameInputController.text,
                "title" : titleInputController.text,
                "description" : descriptionInputController.text,
                "timestamp" : DateTime.now()
              }).then((value){
                print(value.id);
                Navigator.pop(context);
                nameInputController.clear();
                titleInputController.clear();
                descriptionInputController.clear();
              }).catchError((error) => print("error"));
            }

          },
              child: Text("Save"))
        ],
      );
    },
        );
  }

  }

