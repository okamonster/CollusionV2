import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagrem_flutter/models/communitie.dart';
import 'package:instagrem_flutter/models/post.dart';
import 'package:instagrem_flutter/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection("posts").doc(postId).set(
            post.toJson(),
          );

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //コミュニティ作成関数
  Future<String> CreateCommunitie(
    String title,
    String bio,
    String uid,
    String userName,
    Uint8List file,
  ) async {
    String res = "some error occured";
    try {
      String communitieId = const Uuid().v1();
      String photoUrl = await StorageMethods().uploadCommunitieImageToStorage(
        "communitie",
        file,
        communitieId,
        true,
      );
      Communitie communitie = Communitie(
        title: title,
        bio: bio,
        communitieId: communitieId,
        hostId: uid,
        hostName: userName,
        datePublished: DateTime.now(),
        participant: [],
        photoUrl: photoUrl,
      );

      _firestore.collection("communities").doc(communitieId).set(
            communitie.toJson(),
          );
      await _firestore.collection("communities").doc(communitieId).update({
        "partcipant": FieldValue.arrayUnion([uid]),
      });
      await _firestore.collection("communities").doc(communitieId).update({
        "joinUserName": FieldValue.arrayUnion([userName]),
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //コミュニティ参加関数
  Future<String> joinCommunitie(
      String uid, String username, String communitieId) async {
    String res = "some error occured";
    try {
      await _firestore.collection("communities").doc(communitieId).update({
        "partcipant": FieldValue.arrayUnion([uid]),
      });
      await _firestore.collection("communities").doc(communitieId).update({
        "joinUserName": FieldValue.arrayUnion([username]),
      });

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "name": name,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now(),
        });
      } else {
        print("Text is Empty");
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  //コミュニティ投稿
  Future<String> uploadCommunitiePost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
    String communitieId,
  ) async {
    String res = "some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore
          .collection("communities")
          .doc(communitieId)
          .collection("posts")
          .doc(postId)
          .set(
            post.toJson(),
          );

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //delete posts

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(
    String uid,
    String followId,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(uid).get();

      List following = (snap.data()! as dynamic)["following"];

      if (following.contains(followId)) {
        await _firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
