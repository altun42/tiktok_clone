import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/user.dart';
class SearchControler extends GetxController{
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);
  List<User> get searchedUser => _searchedUsers.value;

  searchUser(String typedUser)async{
    _searchedUsers.bindStream(
      firestore.collection("users").where("name",isGreaterThanOrEqualTo: typedUser).snapshots().map((QuerySnapshot query) {
        List<User> relVal = [];
        for (var elem in query.docs) {
          relVal.add(User.fromSnap(elem));
          
        }
        return relVal;
      })
    );
  }
}