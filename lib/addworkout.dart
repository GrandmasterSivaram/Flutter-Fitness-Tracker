import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddWorkout extends StatefulWidget {
  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  String iconame;
  TextEditingController workoutcontroller = TextEditingController();
  TextEditingController durationcontroller = TextEditingController();
  List<String> images = [
    'icons/workouts/american-football.png',
    'icons/workouts/athletics.png',
    'icons/workouts/weightlifting.png',
    'icons/workouts/bars.png',
    'icons/workouts/basketball.png',
    'icons/workouts/bike.png',
    'icons/workouts/boxing.png',
    'icons/workouts/football.png',
    'icons/workouts/swimming.png',
    'icons/workouts/tennis.png',
  ];

  getcurrentuseruid() async {
    var user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  savetodatabase() async {
    var path = Firestore.instance
        .collection('users')
        .document(await getcurrentuseruid())
        .collection('workouts');
   path.document(workoutcontroller.text).setData({
     'workout_name': workoutcontroller.text,
     'duration': durationcontroller.text,
     'iconame':  iconame
   });     
   Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 60),
            alignment: Alignment.center,
            child: Text(
              "Add Workout",
              style: GoogleFonts.montserrat(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: images.map((image) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        iconame = image;
                      });
                    },
                    child: CircleAvatar(
                        radius: 30.0,
                        child: Image(
                          image: AssetImage(image),
                        )),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: workoutcontroller,
                    decoration: InputDecoration(
                        labelText: "Workout Name",
                        labelStyle: GoogleFonts.montserrat(fontSize: 20),
                        prefixIcon: Icon(Icons.fitness_center)),
                  ),
                  TextField(
                    controller: durationcontroller,
                    decoration: InputDecoration(
                        labelText: "How long did you do",
                        labelStyle: GoogleFonts.montserrat(fontSize: 20),
                        prefixIcon: Icon(Icons.timer)),
                  ),
                ],
              )),
          GestureDetector(
            onTap: () => savetodatabase(),
            child: Container(
              width: MediaQuery.of(context).size.width / 2 + 40,
              height: 60,
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Create Workout",
                    style: GoogleFonts.montserrat(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              )),
            ),
          )
        ],
      )),
    );
  }
}
