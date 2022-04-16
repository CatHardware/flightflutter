import 'package:flutter/material.dart';

import '../image/cached_image.dart';

class PetCard extends StatelessWidget {
  const PetCard({
    Key? key,
    this.title,
    this.imageUrl,
    required this.onPressed,
  }) : super(key: key);
  final String? title;
  final String? imageUrl;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Card(
          child: Container(
        color: Colors.blue,
        child: buildListTile(),
      )),
    );
  }

  ListTile buildListTile() {
    return ListTile(
      title: Text(title ?? ""),
      trailing: FlightCacheImage(imageUrl: imageUrl),
    );
  }
}
