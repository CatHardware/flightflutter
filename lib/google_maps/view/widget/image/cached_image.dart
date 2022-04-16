import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FlightCacheImage extends StatelessWidget {
  const FlightCacheImage({
    Key? key,
    this.imageUrl,
  }) : super(key: key);
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.contain,
      imageUrl: imageUrl ?? "",
      placeholder: (context, url) {
        return const CircularProgressIndicator();
      },
    );
  }
}
