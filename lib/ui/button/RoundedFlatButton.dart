import 'package:flutter/material.dart';

class RoundedFlatButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color? color;
  final Color? mouseOverColor;
  final Color? textColor;
  final String? text;

  const RoundedFlatButton(
      {Key? key,
      this.onPressed,
      this.color,
      this.mouseOverColor,
      this.textColor,
      this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text ?? 'Button'),
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(color: Colors.white)),
          primary: color ?? Colors.grey[900],
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.w600)),
      onPressed: onPressed,
    );
  }
}
