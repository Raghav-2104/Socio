import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;
  LikeButton({super.key,required this.isLiked,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:Image(
        image: !isLiked?AssetImage('assets/heartOutline.png'):AssetImage('assets/favourite.png'),
        height: 25,
        width: 25,
      )
    );
  }
}
