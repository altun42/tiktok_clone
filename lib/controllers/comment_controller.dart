import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';

import '../models/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comment = Rx<List<Comment>>([]);
  List<Comment> get comments => _comment.value;

  String _postId = "";
  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comment.bindStream(firestore
        .collection("videos")
        .doc(_postId)
        .collection("comments")
        .snapshots()
        .map((QuerySnapshot query) {
      List<Comment> relValue = [];
      for (var element in query.docs) {
        relValue.add(Comment.fromSnap(element));
      }
      return relValue;
    }));
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection("users")
            .doc(authController.user.uid)
            .get();
        var allDocs = await firestore
            .collection("videos")
            .doc(_postId)
            .collection("comments")
            .get();
        int len = allDocs.docs.length;
        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)["name"],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)["profilePhoto"],
          uid: authController.user.uid,
          id: "Comment $len",
        );
        await firestore
            .collection("videos")
            .doc(_postId)
            .collection("comments")
            .doc("Comment $len")
            .set(comment.toJson());
      }
      ;
      DocumentSnapshot doc =
          await firestore.collection("videos").doc(_postId).get();
      await firestore.collection("videos").doc(_postId).update({
        "commentCount": (doc.data()! as dynamic)["commentCount"] + 1,
      });
    } catch (e) {
      Get.snackbar("Error While Commenting", e.toString());
    }
  }
  likeComment(String id)async{
    var uid = authController.user.uid;
    DocumentSnapshot doc = await firestore.collection("videos").doc(_postId).collection("comments").doc(id).get();
    if ((doc.data()! as dynamic)["likes"].contains(uid)) {
     await firestore.collection("videos").doc(_postId).collection("comments").doc(id).update({
        "likes":FieldValue.arrayRemove([uid]),
      });
      
    }else{
     await firestore.collection("videos").doc(_postId).collection("comments").doc(id).update({
        "likes":FieldValue.arrayUnion([uid]),
      });
      
    }
  }
}
