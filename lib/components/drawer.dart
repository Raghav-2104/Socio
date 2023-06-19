import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socio/components/listTile.dart';

import '../Screens/profile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 75,
            ),
          ),
          MyListTile(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            text: 'HOME',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 15,
          ),
          MyListTile(
              icon: Icon(Icons.person, color: Colors.white),
              text: 'PROFILE',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              }),
          const SizedBox(
            height: 15,
          ),
          MyListTile(
            icon: Icon(Icons.logout, color: Colors.white),
            text: 'LOGOUT',
            onTap: logout,
          ),
        ],
      ),
    );
  }
}
