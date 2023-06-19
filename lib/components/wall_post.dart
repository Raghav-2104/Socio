import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socio/Helper/timeFormat.dart';
import 'package:socio/components/comment.dart';
import 'package:socio/components/like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postID;
  final String time;
  final List<String> like;
  // final String time;
  WallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.time,
      required this.postID,
      required this.like});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.like.contains(currentUser.email);
  }

  void onTap() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postID);

    if (isLiked) {
      postRef.update({
        'like': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'like': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postID)
        .collection('Comments')
        .add({
      'Comment': commentText,
      'CommentedBy': currentUser.email,
      'CommentTime': Timestamp.now()
    });
  }

  void showCommentDialoge() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add Comment'),
              content: TextField(
                controller: _commentController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Add Comment Here'),
              ),
              actions: [
                CloseButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _commentController.clear();
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      addComment(_commentController.text);
                      Navigator.pop(context);
                      _commentController.clear();
                    },
                    child: Text('Add')),
              ],
            ));
  }

  void deletePost() async {
    final commentDocs = await FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postID)
        .collection('Comments')
        .get();
    for (var doc in commentDocs.docs) {
      await FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postID)
          .collection('Comments')
          .doc(doc.id)
          .delete();
    }
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postID)
        .delete();
  }

  // Future<int> commentCount() async {
  //   int count = 0;
  //   final commentDocs = await FirebaseFirestore.instance
  //       .collection('User Posts')
  //       .doc(widget.postID)
  //       .collection('Comments')
  //       .get();
  //   for (var doc in commentDocs.docs) {
  //     await FirebaseFirestore.instance
  //         .collection('User Posts')
  //         .doc(widget.postID)
  //         .collection('Comments')
  //         .doc(doc.id);
  //     count++;
  //   }
  //   print(count);
  //   return count;
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          currentUser.email == widget.user
              ? IconButton(
                  onPressed: deletePost, icon: const Icon(Icons.delete))
              : const SizedBox(),
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/user.png'),
            ),
            title: Text(
              widget.user,
              style: TextStyle(
                  color: Colors.grey[400], fontWeight: FontWeight.w300),
            ),
            subtitle: Text(
              widget.message,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
            trailing: Text(widget.time),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  LikeButton(isLiked: isLiked, onTap: onTap),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.like.length.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                      onPressed: () => showCommentDialoge(),
                      icon: const Icon(
                        Icons.comment,
                        size: 28,
                      )),
                  // Text(
                  //   '',
                  //   style: const TextStyle(
                  //       fontWeight: FontWeight.bold, fontSize: 18),
                  // ),
                ],
              )),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('User Posts')
                .doc(widget.postID)
                .collection('Comments')
                .orderBy('CommentTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return CommentField(
                        text: commentData['Comment'],
                        time: timeFormat(commentData['CommentTime']),
                        user: commentData['CommentedBy']);
                  }).toList());
            },
          )
        ],
      ),
    );
  }
}
