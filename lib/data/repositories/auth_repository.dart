import 'dart:developer';

import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/data/services/base_repository.dart';

class AuthRepository extends BaseRepository {
  final String usersTableName = "users";

  Future<UserModel> signUp({
    required String username,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final formattedPhoneNumber =
          phoneNumber.replaceAll(RegExp(r'\s+'), "".trim());

      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw "Failed to create user";
      }
      // Create userModel and save the user in the db firestore
      final user = UserModel(
        uuId: userCredential.user!.uid,
        username: username,
        fullName: fullName,
        email: email,
        phoneNumber: formattedPhoneNumber,
      );
      await saveUserData(user: user);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw "User not found";
      }
      final user = await getUserData(uuid: userCredential.user!.uid);
      return user;
    } catch (e) {
      log(e.toString());
      throw "User not found";
    }
  }

  Future<void> saveUserData({required UserModel user}) async {
    try {
      await firestore
          .collection(usersTableName)
          .doc(user.uuId)
          .set(user.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<UserModel> getUserData({required String uuid}) async {
    try {
      final doc = await firestore.collection(usersTableName).doc(uuid).get();
      if (doc.exists) {
        throw "Failed to get user data";
      } else {
        return UserModel.fromFireStore(doc);
      }
    } catch (e) {
      log(e.toString());
      throw "Failed to get user data";
    }
  }
}
