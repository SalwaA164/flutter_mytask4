import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mytask4/Data/models/user_data.dart';
class DataSource {
  static Future<UserData?> getUserDataFromFireStore() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return UserData.fromDoc(userDoc);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }

  static UserData?userData;
}