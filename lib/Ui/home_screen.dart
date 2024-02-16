// // ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, sized_box_for_whitespace

// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_drive/Prvider/survey_provider.dart';
import 'package:google_drive/Ui/user_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SurveyProvider googleAdsProvider = Provider.of<SurveyProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Survey App',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: SafeArea(
            child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                    onPressed: () async {
                      await googleAdsProvider.getHeaders();
                      if (googleAdsProvider.headers != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserScreen()));
                      }
                      // GoogleSignInAccount? googleUser =
                      //     await AuthRepository().signInWithGoogle(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.g_mobiledata,
                          color: Colors.red,
                          size: 50,
                        ),
                        const Text("SignIn With Google"),
                      ],
                    )),
              )
            ],
          ),
        )));
  }
}
