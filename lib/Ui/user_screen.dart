// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_drive/Prvider/survey_provider.dart';
import 'package:google_drive/Services/auth_service.dart';
import 'package:google_drive/Ui/home_screen.dart';
import 'package:google_drive/Ui/s1_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(FirebaseAuth.instance.currentUser!.displayName
                      .toString()),
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
                ],
              ),
              InkWell(
                onTap: () {
                  showDilod();
                },
                child: Container(
                  height: 100,
                  width: 200,
                  color: Colors.deepPurpleAccent,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Create Survey",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await AuthService().googleSignOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: const Text("Sign Out"))
            ],
          ),
        ),
      )),
    );
  }

  void showDilod() {
    SurveyProvider surveyProvider =
        Provider.of<SurveyProvider>(context, listen: false);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
              backgroundColor: Colors.white,
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          await surveyProvider.createFolder("S1");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => S1Screen()));

                          // await AuthService().createFolder(drive, "S1");
                        },
                        child: Text('S1'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await surveyProvider.createFolder("S2");
                        },
                        child: Text('S2'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await surveyProvider.createFolder("S3");
                        },
                        child: Text('S3'),
                      ),
                    ],
                  )));
        });
  }
}
