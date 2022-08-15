import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatefulWidget {
  String title;
  String desc;
  String id;
  String time;
  Description({required this.title, required this.desc,required this.id,required this.time});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {

  TextEditingController descController=new TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),centerTitle: true,
        title:  Text(
          widget.title,
          style:
          GoogleFonts.roboto(fontSize: 24, color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: (){
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
                                .doc(widget.id)
                                .collection('mytasks')
                                .doc(widget.time.toString())
                                .delete();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(msg: "Delete successful.",backgroundColor: Colors.grey.shade800,textColor: Colors.white);
                          },
                          child: new Text("Delete",
                              style: GoogleFonts.roboto(
                                  color: Colors.white)))
                    ],
                  );
                });

          }, icon: Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
    physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){
                  editDescription();

              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      widget.desc,
                      style: GoogleFonts.roboto(fontSize: 19, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void editDescription() async{
    showDialog(context: context, builder: (context){
      return AlertDialog(
        elevation: 22,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(12.0))),
        content: TextField(
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          cursorColor: Colors.white,
          controller: descController..text=widget.desc,
           decoration: InputDecoration(
            focusedBorder: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade100,width: 1)),
              focusColor: Colors.grey,
              contentPadding: EdgeInsets.all(10),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Center(child: Text("Description"),)],
              ),
              labelStyle: GoogleFonts.roboto(color: Colors.white70,fontSize: 16),
              hintText: "Enter Description",
              hintStyle: GoogleFonts.roboto(color: Colors.white70,fontSize: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: Colors.grey.shade100,width: 1, ))),
        ),
        actions: [
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
                    .doc(widget.id)
                    .collection('mytasks')
                    .doc(widget.time.toString()).update({
                  'description': descController.text
                });
                Navigator.of(context).pop();
                setState((){
                  widget.desc=descController.text;
                });
                Fluttertoast.showToast(msg: "Update successful",backgroundColor: Colors.grey.shade800,textColor: Colors.white);
              },
              child: new Text("Update",
                  style: GoogleFonts.roboto(
                      color: Colors.white)))
        ],
      );

    });
  }
}
