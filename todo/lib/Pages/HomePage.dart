import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:todo/Pages/addTask.dart';
import 'package:todo/Pages/description.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id = FirebaseAuth.instance.currentUser!.uid;


  @override
  void initState() {
    // TODO: implement initState

    getuid();
    super.initState();
  }

  void getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser!;
    setState(() {
      id = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TODO", style: GoogleFonts.roboto(fontSize: 22)),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Fluttertoast.showToast(msg: "Sign out",backgroundColor: Colors.grey.shade800,textColor: Colors.white);
                },
                icon: Icon(
                  Icons.logout_rounded,
                  size: 30,
                ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 65,
          width: 65,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddTask()));
              },
              elevation: 22,
              child: Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey.shade700,
              splashColor: Colors.grey.shade100,
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(id)
                    .collection('mytasks')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    );
                  } else {
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          var time = docs[index]['time'];
                          var t = (docs[index]['timestamp'] as Timestamp)
                              .toDate();
                          var timeToString = DateFormat.yMd().add_jm()
                              .format(t)
                              .toString()
                              .replaceAll(" ", "  ");
                          return Column(
                            children: [
                              InkWell(
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          elevation: 22,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(28.0))),
                                          content: Text("Delete the task? ",style: GoogleFonts.roboto(fontSize: 20),),
                                          actions: <Widget>[
                                            new TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: new Text("Cancel",
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.white))),
                                            new TextButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('tasks')
                                                      .doc(id)
                                                      .collection('mytasks')
                                                      .doc(time.toString())
                                                      .delete();
                                                  Navigator.of(context).pop();
                                                  Fluttertoast.showToast(msg: "Delete successful.",backgroundColor: Colors.grey.shade800,textColor: Colors.white);
                                                },
                                                child: new Text("Delete",
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.white)))
                                          ],
                                        );
                                      });
                                },
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Description(
                                            title: docs[index]['title'],
                                            desc: docs[index]['description'],
                                            id: id,
                                            time: time,
                                          )));
                                },
                                child: Container(
                                  width: double.infinity,
                                  child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            docs[index]['title'],
                                            style: GoogleFonts.roboto(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            timeToString,
                                            style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                color: Colors.white70),
                                          )
                                        ],)
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(13)),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              )
                            ],
                          );
                        });
                  }
                })));
  }

}