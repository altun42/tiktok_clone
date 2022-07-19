import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/search_controller.dart';

import '../../models/user.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final SearchControler searchControler = Get.put(SearchControler());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormField(
            decoration: InputDecoration(
                filled: false,
                hintText: "Search",
                hintStyle: TextStyle(fontSize: 18, color: Colors.white)),
            onFieldSubmitted: (value) => searchControler.searchUser(value),
          ),
        ),
        body: searchControler.searchedUser.isEmpty
            ? Center(
                child: Text(
                  "Search for user",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: searchControler.searchedUser.length,
                itemBuilder: (context, index) {
                  User user = searchControler.searchedUser[index];
                  return InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profilePhoto,
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
