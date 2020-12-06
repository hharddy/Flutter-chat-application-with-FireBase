import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {

  final Registercallback registercallback;
  final onSuccessful onsuccess;

  SignUp({this.registercallback, this.onsuccess});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var email_controller = TextEditingController();
  var name_controller = TextEditingController();
  var password_controller = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0,top: 50.0),
                child: Text(
                  "Sign up",
                  style: TextStyle(fontSize: 27.0,fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0,top: 10.0),
                height: 4.0,
                width: 50.0,
                color: Color(0xfff34949),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0,top: 25.0),
                  child: Text(
                    "Create new Account",
                    style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w400),
                  )
              ),
              /*
              name textfield
               */
              Container(
                  margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 40.0),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: name_controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xfff34949),
                    ),
                    hintText: 'Name...',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Color(0xffd5dfe5),width: 1.4)
                    )
                  ),
                ),
              ),
              /*
              email textfield
               */
              Container(
                  margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 20.0),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: email_controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Color(0xfff34949),
                    ),
                    hintText: 'Email Address',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Color(0xffd5dfe5),width: 1.4)
                    )
                  ),
                ),
              ),
              /*
              password textfield
               */
              Container(
                  margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 20.0),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: password_controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xfff34949),
                    ),
                    hintText: 'Password',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Color(0xffd5dfe5),width: 1.4)
                    )
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top:30.0),
                child: InkWell(
                  child: Text('Already have account?'),
                  onTap: (){
                    widget.registercallback();
                  },
                ),

              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top:40.0),
                child: MaterialButton(
                  child: Text('Sign up',
                  style: TextStyle(color: Colors.white,fontSize: 18.0),),
                  color: Color(0xfff34949),
                  padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 26.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0)
                  ),
                  onPressed: (){

                    registeruser(email_controller.text, password_controller.text);
                  },
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  void addser(var mail,var name)async{

    return users.add({
      "name":name,
      "email": mail
    }).then((value) {
      print("User added");
      widget.onsuccess();
    }).catchError((onError){
      print("error: ${onError}");
    });
  }


void registeruser(var mail,var pass) async {
  final User user = (await _auth.createUserWithEmailAndPassword(
          email: mail, password: pass))
      .user;

  if (user == null) {
    print("sign up failed!!");
  } else {
    print("user created..");
    addser(mail,name_controller.text);

  }
}
}

typedef Registercallback = void Function();
typedef onSuccessful = void Function();