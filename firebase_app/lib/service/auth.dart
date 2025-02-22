import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //Register
  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Login
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
