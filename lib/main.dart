import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_drive/Prvider/survey_provider.dart';
import 'package:google_drive/Ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SurveyProvider>(
            create: (context) => SurveyProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
// import 'dart:async';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:test_app/Others/database.dart';
// import 'package:test_app/Services/auth_service.dart';
// import 'package:test_app/Services/drive_service.dart';

// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   DBHelper db = DBHelper();
//   await db.initDatabase();
//   runApp(const GoogleDriveApp());
// }

// class GoogleDriveApp extends StatefulWidget {
//   const GoogleDriveApp({super.key});

//   @override
//   State<GoogleDriveApp> createState() => _GoogleDriveAppState();
// }

// class _GoogleDriveAppState extends State<GoogleDriveApp> {
//   String? _fileId;
//   final _driveService = DriveService();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         key: _scaffoldKey,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: _uploadDBFile,
//                 child: const Text('Upload File'),
//               ),
//               const SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: _uploadImage,
//                 child: const Text('Upload Image'),
//               ),
//               const SizedBox(height: 40),
//               ElevatedButton(
//                   onPressed: () async {
//                     await AuthService().googleSignOut();
//                   },
//                   child: const Text('googleSignOut')),
//               ElevatedButton(
//                 onPressed: _downloadFile,
//                 child: const Text('Download File'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// dummy method to showcase uploading of file to google drive
//   Future<void> _uploadFile() async {
//     _showLoader();

//     // 1. create a file to upload
//     final dir = await getApplicationDocumentsDirectory();
//     final filePath = path.join(dir.path, 'upload.txt');
//     final file = File(filePath);
//     await file.writeAsString('Hello World!!!');

//     // 2. upload file to drive
//     _fileId = await _driveService.uploadFile('upload.txt', filePath);

//     _closeLoader();

//     if (_fileId == null) {
//       _showSnackbar('Failed to upload the file!');
//     } else {
//       _showSnackbar('File successfully uploaded: $_fileId');
//     }
//   }

//   Future<void> _uploadDBFile() async {
//     _showLoader();

//     // 1. Get the path to the existing database file
//     final dir = await getApplicationDocumentsDirectory();
//     final filePath = path.join(dir.path, 'survey.db');
//     final file = File(filePath);

//     // 2. Check if the file exists before attempting to upload
//     if (!await file.exists()) {
//       _closeLoader();
//       _showSnackbar('Database file not found at: $filePath');
//       return;
//     }

//     // 3. Upload the existing database file
//     _fileId = await _driveService.uploadFile('survey.db', filePath);

//     _closeLoader();

//     if (_fileId == null) {
//       _showSnackbar('Failed to upload the file!');
//     } else {
//       _showSnackbar('File successfully uploaded: $_fileId');
//     }
//   }

//   Future<void> _uploadImage() async {
//     _showLoader();

//     // 1. Select the image file
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: false, // Allow only single image selection
//       type: FileType.image,
//     );

//     if (result == null) return; // User canceled the selection

//     final file = File(result.files.single.path!);

//     // 2. Upload image to drive
//     _fileId = await _driveService.uploadFile(file.path, file.path);

//     _closeLoader();

//     if (_fileId == null) {
//       _showSnackbar('Failed to upload the image!');
//     } else {
//       _showSnackbar('Image successfully uploaded: $_fileId');
//     }
//   }

//   // Future<void> _uploadImage() async {
//   //   _showLoader();

//   //   // Select image and create a stream (if necessary)
//   //   final imageFile = await FilePicker.platform.pickFiles(
//   //     allowMultiple: false,
//   //     type: FileType.image,
//   //   );

//   //   if (imageFile == null) return; // User canceled

//   //   final filePath = imageFile.files.single.path!;
//   //   var uploadStream = File(filePath).openRead();

//   //   // Prepare for progress tracking
//   //   int totalBytes = await uploadStream.length;
//   //   int uploadedBytes = 0;
//   //   double progress = 0.0;

//   //   // Set up StreamSubscription to track progress
//   //   StreamSubscription<List<int>>? subscription;

//   //   try {
//   //     // Upload image with progress tracking
//   //     subscription = uploadStream.listen((chunk) {
//   //       uploadedBytes += chunk.length;
//   //       progress = uploadedBytes / totalBytes;
//   //       _updateProgress(progress); // Call progress update function
//   //     });

//   //     _fileId =
//   //         await _driveService.uploadFile(filePath, uploadStream.toString());

//   //     subscription.cancel(); // Close subscription after upload

//   //     _closeLoader();

//   //     if (_fileId == null) {
//   //       _showSnackbar('Failed to upload the image!');
//   //     } else {
//   //       _showSnackbar('Image successfully uploaded: $_fileId');
//   //     }
//   //   } catch (error) {
//   //     subscription!.cancel(); // Close subscription on error
//   //     _closeLoader();
//   //     _showSnackbar('Error uploading image: $error');
//   //   }
//   // }

// // Update progress UI based on your implementation
//   void _updateProgress(double progress) {
//     // Update a progress bar, text label, or other UI element
//     // based on the calculated progress value (0.0 to 1.0)
//   }

//   /// dummy method to showcase downloading of file from google drive
//   Future<void> _downloadFile() async {
//     if (_fileId == null) {
//       _showSnackbar('Upload a file first!');
//       return;
//     }

//     _showLoader();

//     // 1. create a path to download the file
//     final dir = await getApplicationDocumentsDirectory();
//     final filePath = path.join(dir.path, 'download.txt');

//     // 2. download the file
//     final id = await _driveService.downloadFile(_fileId!, filePath);

//     // 3. read downloaded file content
//     final content = await File(filePath).readAsString();

//     _closeLoader();

//     if (id == null) {
//       _showSnackbar('Failed to download the file!');
//     } else {
//       _showSnackbar('File successfully downloaded: $content');
//     }
//   }

//   void _showSnackbar(String msg) {
//     ScaffoldMessenger.of(_scaffoldKey.currentContext!)
//         .showSnackBar(SnackBar(content: Text(msg)));
//   }

//   void _showLoader() {
//     showDialog(
//       context: _scaffoldKey.currentContext!,
//       barrierDismissible: false,
//       builder: (context) => Dialog(
//         child: Container(
//           width: 200,
//           height: 200,
//           alignment: Alignment.center,
//           child: const CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }

//   void _closeLoader() {
//     Navigator.pop(_scaffoldKey.currentContext!);
//   }
// }
