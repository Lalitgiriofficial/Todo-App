import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  titleController.dispose();
  descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Add Tasks",
          style: GoogleFonts.roboto(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  maxLength: 30,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade100,width: 1)),
                      focusColor: Colors.grey,
                      labelStyle: GoogleFonts.roboto(color: Colors.white70,fontSize: 16),
                      hintStyle: GoogleFonts.roboto(color: Colors.white70,fontSize: 16),
                      hintText: "Enter Title",
                      labelText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 1, color: Colors.grey))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  maxLines: 5,
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      labelStyle: GoogleFonts.roboto(color: Colors.white70,fontSize: 16),
                      hintStyle: GoogleFonts.roboto(color: Colors.white70,fontSize: 16),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade100,width: 1)),
                    focusColor: Colors.grey,
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Description",
                      hintText: "Enter Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 1, ))),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                      onPressed: () {
                        submitform();
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        )),
                          elevation: MaterialStateProperty.all(10),
                          backgroundColor: MaterialStateColor.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.grey.shade100;
                        } else
                          return Colors.grey.shade800;
                      })),
                      child: Center(
                          child: Text(
                        "Add Task",
                        style: GoogleFonts.roboto(
                            fontSize: 16, color: Colors.white),
                      ))),
                ),
              ],
            )),
      ),
    );
  }

  void submitform() async{
    FirebaseAuth auth=FirebaseAuth.instance;
    final user=await auth.currentUser;
    String uid=user!.uid.toString();
    var time =DateTime.now();
    await FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').doc(time.toString()).set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time
    });
    FocusScope.of(context).unfocus();
    Fluttertoast.showToast(msg: "Task Added",backgroundColor: Colors.grey.shade800,textColor: Colors.white);
    Navigator.of(context).pop();
  }
}
