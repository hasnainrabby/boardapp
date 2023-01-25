import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;
  const CustomCard({Key? key, required this.snapshot, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var snapshotData = snapshot.docs[index];

    var docId = snapshotData.id;
    var timeToDate = DateTime.fromMillisecondsSinceEpoch(
        snapshotData['timestamp'].seconds *1000);
    var dateFormatted = DateFormat("MMM,EEE,d").format(timeToDate);
    var collectionReference = FirebaseFirestore.instance.collection("boardappdatabasecollection#1");

    TextEditingController nameInputController = TextEditingController(text: snapshotData['name']);
    TextEditingController titleInputController = TextEditingController(text: snapshotData['title']);
    TextEditingController descriptionInputController = TextEditingController(text: snapshotData['description']);

    return Column(
      children: [
        Container(
          height: 170,
          child: Card(
            elevation: 15,
            child: Column(
              children: [
                ListTile(
                  title: Text(snapshotData['title']),
                  subtitle: Text(snapshotData["description"].toString()),
                  leading: CircleAvatar(
                    radius: 35,
                    child: Text(snapshotData['title'].toString()[0]),
                  ),
                ),
                //for showing saving date & time
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("by: ${snapshotData['name']}  "),
                      Text((dateFormatted)),
                    ],
                  ),
                ),
                //Update & Delete data from firestore database
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(icon:Icon(Icons.edit,size: 20,),
                      onPressed: () async{
                      await showDialog(context: context,
                          builder: (BuildContext context){
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

                            //update data on firestore from app
                            TextButton(onPressed: (){
                              if(nameInputController.text.isNotEmpty &&
                                  titleInputController.text.isNotEmpty &&
                                  descriptionInputController.text.isNotEmpty){
                                collectionReference.doc(docId).update({
                                  "name" : nameInputController.text,
                                  "title" : titleInputController.text,
                                  "description" : descriptionInputController.text,
                                  "timestamp" : DateTime.now()
                                }).then((value) => Navigator.pop(context));
                              }

                            },
                                child: Text("Update"))
                          ],
                        );
                          });

                    },
                        ),
                    SizedBox(height: 20),

                    IconButton(
                    icon:Icon(Icons.delete,size: 20,),
                        onPressed: () async {
                      await collectionReference
                      .doc(docId).delete();
                    },
                        )
                  ],
                )
                //snapshot.docs[index]['timestamp'].toString())
              ],
            ),
          ),
        ),

      ],
    );
  }
}
