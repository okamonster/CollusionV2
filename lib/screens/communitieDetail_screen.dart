import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagrem_flutter/models/user.dart';
import 'package:instagrem_flutter/resources/firestore_methods.dart';
import 'package:instagrem_flutter/screens/communitie_feed_screen.dart';
import 'package:instagrem_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/utils.dart';

class CommunitieDetail extends StatefulWidget {
  final snap;
  const CommunitieDetail({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  _CommunitieDetailState createState() => _CommunitieDetailState();
}

class _CommunitieDetailState extends State<CommunitieDetail> {
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommunitie();
  }

  void getCommunitie() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("communities")
          .doc(widget.snap["communitieId"])
          .get();
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snap["title"]),
        backgroundColor: mobileBackgroundColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.36,
            width: double.infinity,
            child: Image.network(
              widget.snap["photoUrl"],
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "メンバー",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
          const Divider(),

          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "コミュニティ詳細",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(widget.snap["bio"]),
              )
            ],
          ),

          //参加ボタン
          SizedBox(
            height: 42,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                await FirestoreMethods().joinCommunitie(
                    user.uid, user.username, widget.snap["communitieId"]);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommunitieFeedScreen(
                      snap: widget.snap,
                    ),
                  ),
                );
                setState(() {
                  _isLoading = false;
                });
              },
              child: Container(
                alignment: Alignment.center,
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: primaryColor,
                      )
                    : Text(
                        "参加",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: blueColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
