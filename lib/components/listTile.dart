import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final Icon icon;
  final String text;
  final void Function() onTap;
  MyListTile({super.key, required this.icon, required this.text,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 25),
      leading: icon,
      textColor: Colors.white,
      title: Text(text),
      // tileColor: Colors.white,
      onTap:onTap,
    );
  }
}
