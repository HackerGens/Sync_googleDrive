// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_drive/Services/auth_service.dart';
import 'package:google_drive/Services/drive_service.dart';

class SurveyProvider with ChangeNotifier {
  Map<String, String>? headers;
  final _authService = AuthService();

  getHeaders() async {
    headers = await _authService.googleSignIn();
    notifyListeners();
  }

  //folder id for adding data into that folder
  String? s1Id;
  createFolder(String folderName) async {
    String? id = await DriveService().getFolderId(headers, folderName);

    if (id == null) {
      s1Id = await DriveService().createFolder(folderName);
      print("null ----------------------------------------");
      print(s1Id);
      notifyListeners();
    } else {
      s1Id = id;
      notifyListeners();
      print("is not null ----------------------------------------");
      print(s1Id);
    }
  }
}
