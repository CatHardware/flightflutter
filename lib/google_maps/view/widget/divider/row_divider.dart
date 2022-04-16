import 'package:flutter/material.dart';

class RowDivider extends StatelessWidget {
  const RowDivider({Key? key, this.colors, this.indent, this.thick}) : super(key: key);
  final Color? colors;
  final double? indent;
  final double? thick;

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    return Divider(
      color: colors,
      thickness: thick ?? 3,
      indent: pageWidth * (indent ?? 1),
      endIndent: pageWidth * (indent ?? 1),
    );
  }
}
