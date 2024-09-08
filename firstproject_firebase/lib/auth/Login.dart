//import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject_firebase/auth/register.dart';
import 'package:firstproject_firebase/componen/Containers_webside.dart';
import 'package:firstproject_firebase/componen/TextFormField.dart';
import 'package:firstproject_firebase/componen/materialButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motion_toast/motion_toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  GlobalKey<FormState> key1 = GlobalKey();
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleUser == null) {
      return;
    }
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  "images/login.png",
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 50, right: 10),
            child: Form(
              key: key1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "Login To Continue Using The App",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Email",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  text("Enter your Email", emailcontroller, Icon(Icons.email),
                      (value) {
                    if (value!.isEmpty) {
                      return "Can't empty this field";
                    }
                  }),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Password",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  text("Enter your Password", passwordcontroller,
                      Icon(Icons.visibility), (value) {
                    if (value!.isEmpty) {
                      return "Can't empty this field";
                    }
                  })
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    if (emailcontroller.text == "") {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Dialog Title',
                        desc:
                            'Please enter the email that you want to change it is password',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      )..show();
                    } else {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailcontroller.text);
                        MotionToast(
                          width: 350,
                          height: 50,

                          primaryColor: const Color.fromARGB(255, 13, 71, 161),
                          description: Text(
                              "Check your email and change the password",
                              style: TextStyle(color: Colors.white)),
                          animationType: AnimationType
                              .fromTop, // Show the toast from the top
                          position: MotionToastPosition.top,
                          barrierColor: Colors.black.withOpacity(0.2),
                        ).show(context);
                        /*  AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Dialog Title',
                        desc: 'Check your email and change the password',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      )..show();
                      */
                      } catch (e) {
                        MotionToast(
                          width: 350,
                          height: 50,
                          primaryColor: Colors.red,
                          description: Text("Not Valied this Email,Try Again",
                              style: TextStyle(color: Colors.white)),
                          animationType: AnimationType
                              .fromTop, // Show the toast from the top
                          position: MotionToastPosition.bottom,
                          barrierColor: Colors.black.withOpacity(0.2),
                        ).show(context);
                      }
                    }
                  },
                  child: Container(
                    child: Text(
                      "Forget Password?",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 8, left: 8),
            child: materialbutton(() async {
              if (key1.currentState!.validate()) {
                try {
                  final credential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailcontroller.text,
                    password: passwordcontroller.text,
                  );
                  if (credential.user!.emailVerified) {
                    Navigator.of(context).pushReplacementNamed("homepage");
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Dialog Title',
                      desc: 'Please Open your Email and Verified',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    )..show();
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    //print('No user found for that email.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Dialog Title',
                      desc: 'Wrong Email',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    )..show();
                  } else if (e.code == 'wrong-password') {
                    // print('Wrong password provided for that user.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Dialog Title',
                      desc: 'Wrong Password',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    )..show();
                  }
                }
              } else {
                return "false";
              }
            }, "Login"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 20,
                  child: Divider(
                    color: Colors.grey[300],
                  ),
                ),
                Text(
                  "Or login With",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(
                  width: 120,
                  height: 20,
                  child: Divider(
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {}, child: contwebside(Icons.facebook)),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                    onTap: () {
                      print("menna");
                    },
                    child: contwebside(Icons.apple)),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: contwebside(Icons.email)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't Have Account?",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("Register");
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
