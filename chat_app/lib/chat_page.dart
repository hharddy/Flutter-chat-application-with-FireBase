import 'package:chat_app/message.dart';
import 'package:chat_app/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final Users user;

  ChatPage(this.user);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  var text_controller = TextEditingController();
  final firebaseInstance = FirebaseFirestore.instance.collection('messages');


  var key_relation;

  Widget header(){

    return Row(
      children: [
        SizedBox(width:8.0),
        IconButton(icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,), onPressed: (){}),
        SizedBox(width: 10.0,),
        CircleAvatar(
          radius: 26.0,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage('http://mrgamification.com/wp-content/uploads/2018/02/cell311_1x.png'),

        ),
        SizedBox(width: 17.0,),
        Column(
          children: [
            Text(widget.user.name,style: TextStyle(color: Colors.white,fontSize: 17.0,
            fontWeight: FontWeight.w700),),
            SizedBox(height: 3.0,),
            Text('Online',style: TextStyle(color: Color(0xffc8c7d4),fontSize: 15.0),)
          ],
        )
      ],
    );
  }

  Widget send(){
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12.0,horizontal: 10.0),
              padding: EdgeInsets.only(left: 10.0,right: 3.0,top:2.0,bottom: 2.0),
              decoration: BoxDecoration(
                color: Color(0xfff2f1f6),
                borderRadius: BorderRadius.circular(28.0)
              ),
              child: TextField(
                controller: text_controller,
                style: TextStyle(fontSize: 18.0,color: Color(0xffa8a5b9)),
                decoration: InputDecoration(
                  hintText: 'Write your text..',
                  hintStyle: TextStyle(fontSize: 18.0,color: Color(0xffa8a5b9)),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 13.0,horizontal: 13.0),
            margin: EdgeInsets.only(right:5),
            decoration: BoxDecoration(
              color: Color(0xfff9a3a4),
              borderRadius: BorderRadius.circular(28.0)
            ),
            child: InkWell(
              onTap: (){
                Sendmsg(text_controller.text);
              },
              child: Icon(Icons.send,color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }

  Widget Sender(var text){
    return Align(
      alignment: Alignment.topRight,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 10.0),
        margin: EdgeInsets.only(right: 10,top: 9.0),
        decoration: BoxDecoration(
          color: Color(0xfff8a2a3),
          borderRadius: BorderRadius.circular(7.0)
        ),
        child:Text(text,style: TextStyle(color: Colors.white,fontSize: 18.0),)
      ),
    );
  }

  Widget Receiver(var text){
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 10.0),
          margin: EdgeInsets.only(left: 10,top: 9.0),
          decoration: BoxDecoration(
              color: Color(0xfff1f0f5),
              borderRadius: BorderRadius.circular(7.0)
          ),
          child:Text(text,style: TextStyle(color: Color(0xff1c3865),fontSize: 18.0),)
      ),
    );

  }

  void Sendmsg(var text) async{

    return firebaseInstance.add({
      "message":text,
      "time":int.parse(_getCurrentTime()),
      "sender": _auth.currentUser.uid,
      "receiver":widget.user.userid,
      "relation": key_relation
    }).then((value) {
      print("Message sent");
    }).catchError((error){
      print("Message failed");
    });
  }

  String _getCurrentTime(){
    var now = DateTime.now();
  var date = "${now.year}${now.month.toString().padLeft(2,'0')}${now.day.toString().padLeft(2,'0')}"
      "${now.hour.toString().padLeft(2,'0')}"
      "${now.minute.toString().padLeft(2,'0')}${now.second.toString().padLeft(2,'0')}";
      return date;
  }


  @override
  void initState() {
    key_relation = _auth.currentUser.uid+widget.user.userid;
    docxist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              color: Color(0xff7f7b9c),
              child: header(),
            ),
            Expanded(
              child:Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatlist(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData)
                      return Container(
                        height: 40.0,
                        child: CircularProgressIndicator(),
                      );

                    final  List<Message> children = snapshot.data.docs.map((e) =>
                    Message(e['message'].toString(),e['sender'].toString(),e['receiver'].toString())
                    ).toList();
                    return Container(
                      child: ListView.builder(
                        itemCount: children.length,
                        itemBuilder: (context,index){
                          if(children[index].sender==_auth.currentUser.uid)
                            return Sender(children[index].message);
                          else
                            return Receiver(children[index].message);
                        },
                      ),
                    );
                  },
                ),
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: send(),
            )
          ],
        ),
      ),
    );
  }

  void docxist(){
    firebaseInstance.where('relation',isEqualTo: key_relation).get()
        .then((value)  {
          if(value.docs.isEmpty){
            print("first try failed");
            key_relation = widget.user.userid+_auth.currentUser.uid;

            firebaseInstance.where('relation',isEqualTo: key_relation).get()
            .then((value2) {
              if(value2.docs.isEmpty){
                /*
                first time chat
                 */
              }else{
                setState(() {
                  key_relation = widget.user.userid+_auth.currentUser.uid;

                });
                print("key is ok");
              }
            });
          }
    });

  }
  Stream<QuerySnapshot> _chatlist(){
    return firebaseInstance.where('relation',isEqualTo: key_relation)
        .orderBy('time')
        .snapshots();
  }
}
