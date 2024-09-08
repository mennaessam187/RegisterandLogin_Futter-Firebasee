import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject_firebase/componen/Containers_webside.dart';
import 'package:firstproject_firebase/componen/TextFormField.dart';
import 'package:firstproject_firebase/componen/materialButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController confirmbassword = TextEditingController();
    GlobalKey<FormState> key2 = GlobalKey();
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
                  "images/reg.jpg",
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 50, right: 10),
            child: Form(
              key: key2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Register",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "Enter Your personal information",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Username",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  text("Enter your Name", username, Icon(Icons.person),
                      (value) {
                    if (value!.isEmpty) {
                      return "Can't empty this field";
                    }
                  }),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Email",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  text("Enter your Email", email, Icon(Icons.email), (value) {
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
                  text("Enter your Password", password,
                      const Icon(Icons.visibility), (value) {
                    if (value!.isEmpty) {
                      return "Can't empty this field";
                    }
                  }),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Confirm Password",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  text("Enter your Confirm Password", confirmbassword,
                      const Icon(Icons.visibility), (value) {
                    if (value!.isEmpty) {
                      return "Can't empty this field";
                    }
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 8, left: 8),
            child: materialbutton(() async {
              if (key2.currentState!.validate()) {
                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  Navigator.of(context).pushReplacementNamed("Login");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              } else
                return "false";
            }, "Register"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Have Account?",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("Login");
                  },
                  child: const Text(
                    "Login",
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
