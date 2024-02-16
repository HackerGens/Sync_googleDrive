// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class AuthService {
  static final _instance = AuthService._();
  final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/drive.file'],
  );

  AuthService._();

  factory AuthService() {
    return _instance;
  }

  /// Sign in with Google
  /// returns auth-headers on success, else null
  Future<Map<String, String>?> googleSignIn() async {
    try {
      GoogleSignInAccount? googleAccount;
      if (_googleSignIn.currentUser == null) {
        googleAccount = await _googleSignIn.signIn();
        final GoogleSignInAuthentication gAuth =
            await googleAccount!.authentication;
        final credentials = GoogleAuthProvider.credential(
            idToken: gAuth.idToken, accessToken: gAuth.accessToken);

        await FirebaseAuth.instance.signInWithCredential(credentials);
      } else {
        googleAccount = await _googleSignIn.signInSilently();
      }

      return await googleAccount?.authHeaders;
    } catch (e) {
      return null;
    }
  }

  /// sign out google account
  Future<void> googleSignOut() => _googleSignIn.signOut();

  Future<String?> createFolder(DriveApi drive, String folderName) async {
    final folder = File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder';
    try {
      final response = await drive.files.create(folder);
      return response.id;
    } catch (error) {
      print('Error creating folder: $error');
      return null;
    }
  }
}
