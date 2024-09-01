import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      try {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential.user;
      } on FirebaseAuthException catch (e) {
        print(e);
        return null;
      }
    }
  }

  

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}