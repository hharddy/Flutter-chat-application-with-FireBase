import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {


  final Logincallback logincallback;
  final onSuccessful onsuccess;


  LoginPage({this.logincallback, this.onsuccess});

  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var loading = false;
  var email_controller = TextEditingController();
  var password_controller = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Widget LoadingWidget() {
    if (loading) {
      return CircularProgressIndicator();
    } else {
      return Container();
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
          //width: MediaQuery.of(context).size.width,
          body: SingleChildScrollView (
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 50.0),
                  child: Text(
                    "Log in",
                    style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, top: 10.0),
                  height: 4.0,
                  width: 50.0,
                  color: Color(0xfff34949),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, top: 25.0),
                  child: Text("Please log in to your account",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400)),
                ),
                /*
                    email textfield
                     */
                Container(
                  margin: EdgeInsets.only(right: 30.0, left: 30.0, top: 40.0),
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: email_controller,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Color(0xfff34949),
                        ),
                        hintText: 'Email address',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                            BorderSide(color: Color(0xffd5dfe5), width: 1.4)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                            BorderSide(color: Color(0xffd5dfe5), width: 1.4))),
                  ),
                ),
                /*
                    password textfield
                     */
                Container(
                  margin: EdgeInsets.only(right: 30.0, left: 30.0, top: 20.0),
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: password_controller,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color(0xfff34949),
                        ),
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                            BorderSide(color: Color(0xffd5dfe5), width: 1.4)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                            BorderSide(color: Color(0xffd5dfe5), width: 1.4))),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 30.0),
                  child: InkWell(
                    child: Text('Create new account'),
                    onTap: () {

                      widget.logincallback();
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 40.0),
                  child: MaterialButton(
                    child: Text(
                      'Log in',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    color: Color(0xfff34949),
                    padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 10.0),
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    onPressed: () {

                      loginuser(email_controller.text,password_controller.text);


                    },
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 30.0),
                    child: LoadingWidget())
              ],
            ),
          ),
        )
    );
  }
void loginuser(var mail,var pass) async {
  final User user =
      (await _auth.signInWithEmailAndPassword(email: mail, password: pass))
          .user;

  if (user == null) {
    print("sign in failed!!");
  } else {
    print("user login..");
    widget.onsuccess();

  }
}

}
typedef Logincallback = void Function();
typedef onSuccessful = void Function();
