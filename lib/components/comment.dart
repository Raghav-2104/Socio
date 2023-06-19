import 'package:flutter/material.dart';

class CommentField extends StatefulWidget {
  final String text;
  final String user;
  final String time;
  const CommentField({super.key,required this.text,required this.time,required this.user});

  @override
  State<CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.user),
                  const SizedBox(width: 15,),
                  Text(widget.time)
                ],
              ),
              const SizedBox(height: 5,),
              Text(widget.text),
              const SizedBox(height: 5,)
            ],
          ),
        )
      ),
    );
  }
}
