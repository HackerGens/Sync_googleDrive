// ignore_for_file: avoid_print, prefer_const_declarations

import 'dart:io';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:google_drive/Services/auth_service.dart';
import 'package:google_drive/Services/httpClient.dart';

class DriveService {
  final _authService = AuthService();

  /// upload file in the google drive
  /// returns id of the uploaded file on success, else null
  Future<String?> uploadFile(String fileName, String filePath, savedHeaders,
      String folderId, context) async {
    final file = File(filePath);

    // 1. sign in with Google to get auth headers
    // final headers = await _authService.googleSignIn();
    final headers = savedHeaders;
    if (headers == null) return null;

    // 2. create auth http client & pass it to drive API
    final client = DriveClient(headers);
    final drive = ga.DriveApi(client);

    // 3. check if the file already exists in the google drive
    final fileId = await _getFileID(drive, fileName);

    // 4. if the file does not exists in the google drive, create a new one
    // else update the existing file
    if (fileId == null) {
      final res = await drive.files.create(
        ga.File()
          ..name = fileName
          ..parents = [folderId], // Set the parent folder ID
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
      );
      // final res = await drive.files.create(
      //   ga.File()..name = fileName,
      //   uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
      // );
      return res.id;
    } else {
      final res = await drive.files.update(
        ga.File()..name = fileName,
        fileId,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
      );
      return res.id;
    }
  }

  /// returns file id for existing file,
  /// returns null if file does not exists
  Future<String?> getFolderId(savedHeaders, String folderName) async {
    // 1. sign in with Google to get auth headers
    // final headers = await _authService.googleSignIn();
    final headers = savedHeaders;
    if (headers == null) return null;

    // 2. create auth http client & pass it to drive API
    final client = DriveClient(headers);
    final drive = ga.DriveApi(client);
    // **Enhanced query structure:**
    final list = await drive.files.list(
      q: "mimeType='application/vnd.google-apps.folder' and trashed=false",
      $fields: 'nextPageToken, files(id, name)',
      spaces: 'drive',
    );

    // **Clearer error handling:**
    if (list.files?.isEmpty ?? true) {
      print("Folder not found: $folderName");
      return null;
    }

    return list.files!.first.id; // Use "!" for null-safety
  }

  Future<String?> _getFileID(ga.DriveApi drive, String fileName) async {
    final mimeType = "application/vnd.google-apps.folder";
    final list = await drive.files.list(
      q: "mimeType = '$mimeType' and name = '$fileName'",
      $fields: "files(id, name)",
    );
    if (list.files?.isEmpty ?? true) return null;
    return list.files?.first.id;
  }

  /// download the file from the google drive
  /// @params [fileId] google drive id for the uploaded file
  /// @params [filePath] file path to copy the downloaded file
  /// returns download file path on success, else null
  Future<String?> downloadFile(String fileId, String filePath) async {
    // 1. sign in with Google to get auth headers
    final headers = await _authService.googleSignIn();
    if (headers == null) return null;

    // 2. create auth http client & pass it to drive API
    final client = DriveClient(headers);
    final drive = ga.DriveApi(client);

    // 3. download file from the google drive
    final res = await drive.files.get(
      fileId,
      downloadOptions: ga.DownloadOptions.fullMedia,
    ) as ga.Media;

    // 4. convert downloaded file stream to bytes
    final bytesArray = await res.stream.toList();
    List<int> bytes = [];
    for (var arr in bytesArray) {
      bytes.addAll(arr);
    }

    // 5. write file bytes to disk
    await File(filePath).writeAsBytes(bytes);
    return filePath;
  }

  /// Create a new folder in Google Drive.
  ///
  /// Returns the ID of the created folder on success, or null on failure.
  Future<String?> createFolder(String folderName) async {
    // 1. Sign in with Google to get auth headers
    final headers = await _authService.googleSignIn();
    if (headers == null) return null;

    // 2. Create an authorized HTTP client and Drive API instance
    final client = DriveClient(headers);
    final drive = ga.DriveApi(client);

    // 3. Create a new folder
    final folder = ga.File()
      ..name = folderName
      ..mimeType = "application/vnd.google-apps.folder";
    try {
      final response = await drive.files.create(folder);
      return response.id;
    } catch (error) {
      print('Error creating folder: $error');
      return null;
    }
  }
}
