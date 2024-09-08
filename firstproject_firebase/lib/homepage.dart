import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motion_toast/motion_toast.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        actions: [
          IconButton(
              onPressed: () async {
                // Create an instance of GoogleSignIn
                GoogleSignIn googleSignIn = GoogleSignIn();

                // Check if the user is signed in with Google
                GoogleSignInAccount? googleUser = googleSignIn.currentUser;

                if (googleUser != null) {
                  // User is signed in with Google, so sign out from Google
                  await googleSignIn.disconnect();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("Login", (route) => false);
                } else {
                  await FirebaseAuth.instance.signOut();

                  // Navigate to the login screen after signing out
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("Login", (route) => false);
                }

                // In either case, sign out from Firebase authentication

                /*
                GoogleSignIn sighnin = GoogleSignIn();
                sighnin.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("Login", (route) => false);
                    */
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Column(children: [
        MaterialButton(
          onPressed: () {
            MotionToast(
              width: 350,
              height: 50,
              primaryColor: Colors.red,
              description:
                  Text("message", style: TextStyle(color: Colors.white)),
              animationType:
                  AnimationType.fromTop, // Show the toast from the top
              position: MotionToastPosition.top,
              barrierColor: Colors.black.withOpacity(0.2),
            ).show(context);
          },
          child: Text("daialog"),
        )
      ]),
    );
  }
}
