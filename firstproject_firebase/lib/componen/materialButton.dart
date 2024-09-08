import 'package:flutter/material.dart';

MaterialButton materialbutton(Function()? onPressed, String text) {
  return MaterialButton(
    onPressed: onPressed,
    color: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    minWidth: 100,
    height: 60,
    child: Text(
      "$text",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
