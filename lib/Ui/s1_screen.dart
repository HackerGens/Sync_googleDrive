// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_drive/Prvider/survey_provider.dart';
import 'package:google_drive/Services/drive_service.dart';

class S1Screen extends StatefulWidget {
  const S1Screen({super.key});

  @override
  State<S1Screen> createState() => _S1ScreenState();
}

class _S1ScreenState extends State<S1Screen> {
  String? _fileId;
  final _driveService = DriveService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () async {
          await uploadImage();
        },
        child: Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Survey 1',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [],
          ),
        ),
      )),
    );
  }

  Future<void> uploadImage() async {
    SurveyProvider surveyProvider =
        Provider.of<SurveyProvider>(context, listen: false);

    print(surveyProvider.s1Id!.toString());
    _showLoader();

    // 1. Select the image file
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Allow only single image selection
      type: FileType.image,
    );

    if (result == null) return; // User canceled the selection

    final file = File(result.files.single.path!);
    print(".................................");
    print(surveyProvider.s1Id.toString());
    final timestamp = DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
    String name = "img-$timestamp";
    // 2. Upload image to drive
    _fileId = await _driveService.uploadFile(name, file.path,
        surveyProvider.headers, surveyProvider.s1Id.toString(), context);

    _closeLoader();

    if (_fileId == null) {
      _showSnackbar('Failed to upload the image!');
    } else {
      _showSnackbar('Image successfully uploaded: $_fileId');
      print("--------------------------------------------------------");
      print('Image successfully uploaded: $_fileId');
      print('Image successfully uploaded: $_fileId');
      print("--------------------------------------------------------");
    }
  }

  void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _closeLoader() {
    Navigator.pop(context);
  }
}
