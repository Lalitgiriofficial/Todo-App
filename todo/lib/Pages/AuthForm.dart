import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String errormessage="";
  bool haserror=false;
  GlobalKey<FormState> _formstate = GlobalKey<FormState>();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  String _username = '';
  String _email = '';
  String _password = '';
  bool isLoginPage = false;
  late StreamSubscription mystreamsubscription;
  var isDeviceConnected=false;
  bool alertBox = false;
  @override
  void initState() {
    // TODO: implement initState
    getConnectivity();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  emailcontroller.dispose();
  passwordcontroller.dispose();
  usernamecontroller.dispose();
  mystreamsubscription.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 240,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/vector_image.png"),
                    fit: BoxFit.fill,
                  )
                ),
              ),
             SizedBox(height: 20,),
              Container(
                child: Form(
                    key: _formstate,
                    child: Column(
                      children: [
                        if (!isLoginPage)
                          TextFormField(
                            onSaved: (value) {
                              _username = value.toString();
                            },
                            controller: usernamecontroller,
                            key: ValueKey('username'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Invalid Username";
                              } else
                                return null;
                            },
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                focusedBorder: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey.shade100,width: 1)),
                                focusColor: Colors.grey,
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [Center(child: Text("Username"),)],
                                ),
                                labelStyle: GoogleFonts.roboto(color: Colors.white70,fontSize: 16),
                                hintText: "Enter username",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 1))),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            onSaved: (value) {
                              _email = value.toString();
                            },
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return "Invalid email";
                              } if(haserror==true){
                                return errormessage;
                              }else
                                return null;
                            },
                            controller: emailcontroller,
                            key: ValueKey('email'),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                focusedBorder: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey.shade100,width: 1)),
                                focusColor: Colors.grey,
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [Center(child: Text("Email"),)],
                                ),
                                labelStyle: GoogleFonts.roboto(color: Colors.white70,fontSize: 16),
                                hintText: "Enter Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 1)))),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onSaved: (value) {
                            _password = value.toString();
                          },
                          validator: (value) {
                            if (value!.isEmpty || value.length < 8) {
                              return "Invalid password";
                            }if(haserror==true){
                              return errormessage;
                            }
                            else
                              return null;
                          },
                          controller: passwordcontroller,
                          key: ValueKey('Password'),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              focusedBorder: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade100,width: 1)),
                              focusColor: Colors.grey,
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [Center(child: Text("Password"),)],
                              ),
                              labelStyle: GoogleFonts.roboto(color: Colors.white70,fontSize: 16),
                              hintText: "Enter password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(width: 1))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState((){
                              haserror=false;
                            });
                             getConnectivity();
                             startAuthentication();
                          },
                          child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width/3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade800,
                              ),
                              child: isLoginPage
                                  ? Center(
                                      child: Text("Login",
                                          style: GoogleFonts.roboto(fontSize: 16)))
                                  : Center(
                                      child: Text(
                                        "SignUp",
                                        style: GoogleFonts.roboto(fontSize: 16),
                                      ),
                                    )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () => toggle(),
                          child: isLoginPage
                              ? Text("Not a member? Signup")
                              : Text("Already a member? Login"),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggle() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  void startAuthentication() {
    final validity = _formstate.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formstate.currentState!.save();
      submitForm();
    }
  }

  void submitForm() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLoginPage) {
        try{
          authResult = await auth.signInWithEmailAndPassword(
              email: _email, password: _password);
        }on FirebaseException catch(error){
          setState((){
            errormessage=error.message!;
            haserror=true;
            startAuthentication();
          });
        }
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        String id = authResult.user!.uid.toString();
        await FirebaseFirestore.instance.collection('users').doc(id).set(
            {'email': _email, 'username': _username, 'password': _password});
      }
    } catch (err) {
      print(err);
    }
  }

  void getConnectivity() {
    mystreamsubscription=Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async{
      isDeviceConnected =await InternetConnectionChecker().hasConnection;
      if(!isDeviceConnected && alertBox==false){
        showDialogueBox();
        setState(() => alertBox= true);
      }
    });
  }
  void showDialogueBox() {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text("Please check your internet connection",style: GoogleFonts.roboto(fontSize: 19,color: Colors.white70)),
        title: Text("No Connection",style: GoogleFonts.roboto(fontSize: 15,color: Colors.white70),),
        actions: [
          TextButton(onPressed: ()async{
            Navigator.pop(context);
            setState((){
              alertBox=false;
            });
            isDeviceConnected=await InternetConnectionChecker().hasConnection;
            if(!isDeviceConnected && alertBox==false){
              showDialogueBox();
              setState((){
                alertBox=true;
              });
            }
          }, child: Text("Ok"))
        ],
      );
    });

  }
}
