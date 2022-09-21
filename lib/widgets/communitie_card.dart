import 'package:flutter/material.dart';
import 'package:instagrem_flutter/models/communitie.dart';
import 'package:instagrem_flutter/screens/add_communities_screen.dart';
import 'package:instagrem_flutter/screens/communitieDetail_screen.dart';

class CommunitieCard extends StatefulWidget {
  final snap;

  const CommunitieCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  _CommunitieCardState createState() => _CommunitieCardState();
}

class _CommunitieCardState extends State<CommunitieCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CommunitieDetail(snap: widget.snap),
        ),
      ),
      child: Container(
        height: 250,
        child: Text(
          widget.snap["title"],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(
            image: NetworkImage(widget.snap["photoUrl"]),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
