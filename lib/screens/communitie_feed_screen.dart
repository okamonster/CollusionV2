import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagrem_flutter/models/user.dart';
import 'package:instagrem_flutter/providers/user_provider.dart';
import 'package:instagrem_flutter/screens/add_post_screen.dart';
import 'package:instagrem_flutter/screens/create_post_screen.dart';
import 'package:instagrem_flutter/utils/colors.dart';
import 'package:instagrem_flutter/utils/utils.dart';
import 'package:instagrem_flutter/widgets/post_card.dart';
import 'package:provider/provider.dart';

class CommunitieFeedScreen extends StatefulWidget {
  final snap;
  const CommunitieFeedScreen({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<CommunitieFeedScreen> createState() => _CommunitieFeedScreenState();
}

class _CommunitieFeedScreenState extends State<CommunitieFeedScreen> {
  Uint8List? _file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text(
          widget.snap["title"],
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.messenger_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("communities")
                  .doc(widget.snap["communitieId"])
                  .collection("posts")
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              },
            ),
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              IconButton(
                iconSize: 64,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreatePostScreen(
                        snap: widget.snap,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.add_circle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
