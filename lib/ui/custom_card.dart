import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;
  const CustomCard({Key? key, required this.snapshot, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(snapshot.docs[index]['title']),
          subtitle: Text(snapshot.docs[index]["description"].toString()),
          leading: CircleAvatar(
            radius: 35,
            child: Text(snapshot.docs[index]['title'].toString()[0]),
          ),
        )
        //Text(snapshot.docs[index]['title'])
      ],
    );
  }
}
