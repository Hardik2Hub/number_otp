import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_otp/file_store.dart';

class view extends StatefulWidget {
  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['contact']),
                trailing: Wrap(children: [
                  IconButton(
                      onPressed: () {
                        users
                            .doc(document.id)
                            .delete()
                            .then((value) => print("User Deleted"))
                            .catchError((error) =>
                                print("Failed to delete user: $error"));
                      },
                      icon: Icon(Icons.delete)),
                  IconButton(onPressed: () {
                    Navigator.pushReplacement(context, CupertinoPageRoute(
                      builder: (context) {
                        return file_store(document.id,data);
                      },
                    ));
                  }, icon: Icon(Icons.edit)),
                ]),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
