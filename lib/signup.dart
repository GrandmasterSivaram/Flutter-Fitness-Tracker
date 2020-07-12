import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  signup() {
    print(emailcontroller.text.toString());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailcontroller.text.toString() + '@fitness.com',
      password: passwordcontroller.text.toString(),
    ).then((signeduser) {
      User().storeUser(signeduser.user, emailcontroller.text.toString(), context);
      print("the uid is ${signeduser.user.uid}");
    }).catchError((error){
      print("the error os $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 70.0, left: 30.0),
              child: Text(
                "Sign Up for adding workouts",
                style: GoogleFonts.montserrat(fontSize: 25),
              ),
            ),
            SizedBox(height: 70.0),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: GoogleFonts.montserrat(fontSize: 15)),
                    controller: emailcontroller,
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.montserrat(fontSize: 15)),
                    controller: passwordcontroller,
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.yellow),
                    alignment: Alignment.center,
                    child: Center(
                        child: GestureDetector(
                            onTap: () => signup(),
                            child: Text("Sign Up",
                                style: GoogleFonts.montserrat(fontSize: 20)))),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}

class User{
  storeUser(user,email,context)async{
    DocumentReference userReference = Firestore.instance.collection('users').document(user.uid);
    userReference.setData({
      'email': email + '@fitness.com',
      'uid' : user.uid,
      'username':email

    });
  }
}
