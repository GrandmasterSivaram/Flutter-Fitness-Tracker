import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_fitness/workouts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_fitness/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'addworkout.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSigned = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  getcurrentuseruid() async {
    var user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((useraccount) {
      controlsigninuser(useraccount);
    }).onError((e) {
      print(e);
    });
  }

  List<String> workoutnames = [
    'PushUps',
    'Go to nearby Gym',
    'Go cycling',
    "Take some rest",
    "Eat healthy food",
    "Do squats"
  ];
  var randomlist = new List.generate(1, (_) => Random().nextInt(6));

  controlsigninuser(FirebaseUser useraccount) async {
    if (useraccount == null) {
      setState(() {
        isSigned = false;
      });
    } else {
      setState(() {
        isSigned = true;
      });
    }
    print(isSigned);
  }

  delete(String title) async {
    await Firestore.instance
        .collection('users')
        .document(await getcurrentuseruid())
        .collection('workouts')
        .document(title)
        .delete();
    setState(() {});
  }

  getworkouts() async {
    var alldocuments = await Firestore.instance
        .collection('users')
        .document(await getcurrentuseruid())
        .collection('workouts')
        .getDocuments();

    List<Workouts> workoutlist = [];
    for (var document in alldocuments.documents) {
      Workouts workouts = Workouts(
          document['workout_name'], document['iconame'], document['duration']);
      workoutlist.add(workouts);
    }
    return workoutlist;
  }

  homescreen() {
    return Scaffold(
        floatingActionButton: Container(
            decoration:
                BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
            child: IconButton(
              icon: Icon(Icons.fitness_center),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddWorkout()));
              },
              color: Colors.black,
              splashColor: Colors.amber,
              iconSize: 40,
            )),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20.0, top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Workouts",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700, fontSize: 25),
                    ),
                    RaisedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        child: Text("Sign Out",
                            style: GoogleFonts.montserrat(fontSize: 20)),
                        color: Colors.deepOrange)
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width - 50,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.blue[200]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("YOUR NEXT WORKOUT",
                        style: GoogleFonts.montserrat(fontSize: 18)),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      workoutnames[randomlist[0]],
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, top: 20.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Your Workouts",
                      style: GoogleFonts.montserrat(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Icon(Icons.refresh, size: 35))
                  ],
                ),
              ),
              FutureBuilder(
                  future: getworkouts(),
                  builder: (BuildContext context, dataSnapshot) {
                    if (!dataSnapshot.hasData) {
                      return Center(
                        child: Text("Loading.."),
                      );
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dataSnapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Image(
                                  image: AssetImage(
                                      dataSnapshot.data[index].iconame),
                                ),
                              ),
                              title: Text(dataSnapshot.data[index].name,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                              subtitle: Text(dataSnapshot.data[index].duration,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20)),
                              trailing: GestureDetector(
                                  onTap: () =>
                                      delete(dataSnapshot.data[index].name),
                                  child: Icon(Icons.delete,
                                      color: Colors.red, size: 40)),
                            ),
                          );
                        });
                  })
            ],
          ),
        ));
  }

  signin() {
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text.toString() + '@fitness.com',
        password: passwordcontroller.text.toString());
  }

  loginscreen() {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 70.0, left: 30.0),
              child: Text(
                "Get Ready for being FIT",
                style: GoogleFonts.montserrat(fontSize: 26),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 30.0),
              child: Text(
                "Sign In!",
                style: GoogleFonts.montserrat(fontSize: 26),
              ),
            ),
            SizedBox(
              height: 70.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: GoogleFonts.montserrat(fontSize: 15)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.montserrat(fontSize: 15)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 200,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    color: Colors.yellow,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 40.0,
                      ),
                      Icon(Icons.arrow_back),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.montserrat(fontSize: 20),
                          ))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                    color: Colors.yellow,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 40.0,
                      ),
                      GestureDetector(
                          onTap: () => signin(),
                          child: Text(
                            "Sign in",
                            style: GoogleFonts.montserrat(fontSize: 20),
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            )
          ],
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (isSigned) {
      return homescreen();
    } else {
      return loginscreen();
    }
  }
}
