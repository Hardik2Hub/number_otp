import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_otp/view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: file_store(),
    debugShowCheckedModeBanner: false,
  ));
}

class file_store extends StatefulWidget {
  String? id;
  Map<String, dynamic>? data;

  file_store([this.id, this.data]);

  @override
  State<file_store> createState() => _file_storeState();
}

class _file_storeState extends State<file_store> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      t1.text = widget.data!['name'];
      t2.text = widget.data!['contact'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue),
      body: Column(children: [
        TextField(
          controller: t1,
        ),
        TextField(
          controller: t2,
          keyboardType: TextInputType.number,
        ),
        TextButton(
            onPressed: () {
              String name = t1.text;
              String contact = t2.text;

              if (widget.id != null) {
                users
                    .doc(widget.id)
                    .update({'name': name, 'contact': contact})
                    .then((value) => print("User Updated"))
                    .catchError(
                        (error) => print("Failed to update user: $error"));
              } else {
                users
                    .add({
                      'name': name, // John Doe
                      'contact': contact, // Stokes and Sons
                    })
                    .then((value) => print("User Added"))
                    .catchError((error) => print("Failed to add user: $error"));
              }
            },
            child: Text("Submit")),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(
                builder: (context) {
                  return view();
                },
              ));
            },
            child: Text("View")),
      ]),
    );
  }
}
