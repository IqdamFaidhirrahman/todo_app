import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthService() {
    _user = _auth.currentUser;
  }

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "Email tidak ditemukan. Silakan daftar terlebih dahulu.";
      case 'wrong-password':
        return "Password salah. Silakan coba lagi.";
      case 'email-already-in-use':
        return "Email sudah digunakan. Gunakan email lain.";
      case 'invalid-email':
        return "Email tidak valid. Masukkan email yang benar.";
      case 'weak-password':
        return "Password terlalu lemah. Gunakan kombinasi lebih kuat.";
      default:
        return e.message ?? "Terjadi kesalahan. Silakan coba lagi.";
    }
  }
}
