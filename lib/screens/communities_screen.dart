import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagrem_flutter/screens/add_communities_screen.dart';
import 'package:instagrem_flutter/utils/colors.dart';
import 'package:instagrem_flutter/widgets/communitie_card.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({Key? key}) : super(key: key);

  @override
  _CommunitiesScreenState createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  final TextEditingController serachCommunitiesController =
      TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    serachCommunitiesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          decoration: const InputDecoration(
            labelText: "コミュニティを検索",
          ),
          controller: serachCommunitiesController,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 24,
            ),
            //コミュニティ作成ボタン
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => addCommunitiesScreen(),
                ),
              ),
              child: Container(
                child: Text("コミュニティを作成"),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.4),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),
            //一覧

            FutureBuilder(
              future:
                  FirebaseFirestore.instance.collection("communities").get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return MasonryGridView.count(
                  crossAxisCount: 2,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => CommunitieCard(
                    snap: (snapshot.data! as dynamic).docs[index].data(),
                  ),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
