import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rejusicla_app/app_screens/auth_screen.dart';
import 'package:rejusicla_app/app_screens/upload_screen.dart';
import 'package:rejusicla_app/loading_widget.dart';
import 'package:rejusicla_app/models/post.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _cardUI(Post post) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 10.0,
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  post.date,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                ),
                Text(post.time,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic))
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Image.network(
              post.imageUrl,
              width: double.infinity,
              height: 300.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(post.description,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UploadScreen()));
              },
              child: Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut().whenComplete(() {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AuthScreen()));
                }).catchError((error) {
                  Fluttertoast.showToast(msg: error.toString());
                });
              },
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: circularProgress(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> postMap =
                      snapshot.data.docs[index].data();

                  Post post = Post(
                    postMap["imageUrl"],
                    postMap["description"],
                    postMap["data"],
                    postMap["time"],
                  );
                  return _cardUI(post);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
