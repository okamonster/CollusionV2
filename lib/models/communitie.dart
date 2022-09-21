import 'package:cloud_firestore/cloud_firestore.dart';

class Communitie {
  final String title;
  final String bio;
  final String communitieId;
  final String hostId;
  final String hostName;
  final datePublished;
  final participant;
  final String photoUrl;

  const Communitie({
    required this.title,
    required this.bio,
    required this.communitieId,
    required this.hostId,
    required this.hostName,
    required this.datePublished,
    required this.participant,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "bio": bio,
        "communitieId": communitieId,
        "hostId": hostId,
        "hostName": hostName,
        "datePublised": datePublished,
        "partcipant": participant,
        "photoUrl": photoUrl,
      };

  static Communitie fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Communitie(
      title: snapshot["title"],
      bio: snapshot["bio"],
      communitieId: snapshot["communitieId"],
      hostId: snapshot["hostId"],
      hostName: snapshot["hostName"],
      datePublished: snapshot["datePublished"],
      participant: snapshot["participant"],
      photoUrl: snapshot["photoUrl"],
    );
  }
}
