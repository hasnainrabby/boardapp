import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;
  const CustomCard({Key? key, required this.snapshot, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var timeToDate = DateTime.fromMillisecondsSinceEpoch(
        snapshot.docs[index]['timestamp'].seconds *1000);
    var dateFormatted = DateFormat("MMM,EEE,d").format(timeToDate);
    return Column(
      children: [
        Container(
          height: 130,
          child: Card(
            elevation: 15,
            child: Column(
              children: [
                ListTile(
                  title: Text(snapshot.docs[index]['title']),
                  subtitle: Text(snapshot.docs[index]["description"].toString()),
                  leading: CircleAvatar(
                    radius: 35,
                    child: Text(snapshot.docs[index]['title'].toString()[0]),
                  ),
                ),
                //for showing saving date & time
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("by: ${snapshot.docs[index]['name']}  "),
                      Text((dateFormatted)),
                    ],
                  ),
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
