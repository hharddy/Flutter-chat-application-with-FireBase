import 'package:chat_app/user.dart';
import 'package:chat_app/user.dart';
import 'package:chat_app/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';


class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final firestoreInstance = FirebaseFirestore.instance.collection("users");




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          title: Text('Chat list'),
          actions: [
            IconButton(icon: Icon(Icons.exit_to_app_outlined), onPressed: (){}),
            IconButton(icon: Icon(Icons.person), onPressed: (){}),
          ],
        ),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream:_userlist() ,
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return CircularProgressIndicator();
              }
              final List<Users> children = snapshot.data.docs.map((doc) =>
                  Users(doc['name'].toString(),doc['userid'].toString(),doc['email'].toString())
              ).toList();

              return Container(
                child: ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (context,index){
                    return list_row(children[index]);
                  },
                ),
              );
            },
          )
        )
      ),
    );

  }

  Widget list_row(Users user){

    return InkWell(
      onTap: (){

        Navigator.push(
          context,MaterialPageRoute(builder: (context)=> ChatPage(user))
        );
      },
      child: Container(
        margin: EdgeInsets.only(left:10,top:20),
        child: Row(
          children: [

            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage('https://www.marismith.com/wp-content/uploads/2014/07/facebook-profile-blank-face.jpeg'),
              backgroundColor: Colors.transparent,
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text(user.name,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),),
            )
          ],
        ),
      ),
    );
  }
  Stream<QuerySnapshot> _userlist(){

   return firestoreInstance.where('userid',isNotEqualTo: _auth.currentUser.uid).snapshots();
  }
}

