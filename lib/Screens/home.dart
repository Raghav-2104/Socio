import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socio/Helper/timeFormat.dart';
import 'package:socio/Widgets/text_field.dart';
import 'package:socio/components/drawer.dart';
import 'package:socio/components/wall_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  final textController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser!;
  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('User Posts').add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'like':[]
      });
      textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Socio'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postID:post.id,
                          like:List<String>.from(post['like'] ?? []),
                          time: timeFormat(post['TimeStamp'])
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        controller: textController,
                        hintText: 'Write your message',
                        ObscureText: false),
                  ),
                  IconButton(onPressed: postMessage, icon: Icon(Icons.send)),
                ],
              ),
            ),
            Text('Logged in as '+currentUser.email!),
          ],
        ),
      ),
    );
  }
}
