import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskTxtController = TextEditingController();
  final TextEditingController _taskpriceController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final TextEditingController _taskCatController = TextEditingController();

  final Firestore _db = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    getUid();
    super.initState();
  }

  void getUid() async {
    FirebaseUser u = await _auth.currentUser();
    setState(() {
      user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        elevation: 4,
        backgroundColor: primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person_outline),
              onPressed: () {
                _auth.signOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Instant Trolley'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _db
              .collection("users")
              .document(user.uid)
              .collection("tasks")
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.isNotEmpty) {
                return ListView(
                  children: snapshot.data.documents.map((snap) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: FittedBox(
                              child: Text('\$${snap.data["price"]}'),
                            ),
                          ),
                        ),
                        title: Text(
                          snap.data["task"],
                          //style: Theme.of(context).textTheme.title,
                        ),
                        subtitle: Text(
                          snap.data["category"],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _db
                                .collection("users")
                                .document(user.uid)
                                .collection("tasks")
                                .document(snap.documentID)
                                .delete();
                          },
                        ),
                      ),
                    );
                    // Card(
                    //   //color: Colors.white70,
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.only(
                    //           topLeft: Radius.circular(7),
                    //           topRight: Radius.circular(7),
                    //           bottomRight: Radius.circular(7),
                    //           bottomLeft: Radius.circular(7))),
                    //   elevation: 7,
                    //   child: ListTile(
                    //     title: Text(snap.data["task"]),
                    //     onTap: () {},
                    //     trailing: IconButton(
                    //       icon: Icon(Icons.delete, color: Colors.red),
                    //       onPressed: () {
                    //         _db
                    //             .collection("users")
                    //             .document(user.uid)
                    //             .collection("tasks")
                    //             .document(snap.documentID)
                    //             .delete();
                    //       },
                    //     ),
                    //   ),
                    // );
                  }).toList(),
                );
              } else {
                return Container(
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/images/no_task.png"),
                    ),
                  ),
                );
              }
            }
            return Container(
              child: Center(
                child: Image(
                  image: AssetImage("assets/images/no_task.png"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text("Add new products"),
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: TextField(
                  controller: _taskTxtController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your product name here",
                      labelText: "Product Name"),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: _taskpriceController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your product price here",
                      labelText: "Product Price"),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: _taskCatController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your product category here",
                      labelText: "Product Category"),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: _taskDescController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your product description here",
                      labelText: "Product Description"),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    RaisedButton(
                      color: primaryColor,
                      child: Text("Add"),
                      onPressed: () async {
                        String task = _taskTxtController.text.trim();
                        String desc = _taskDescController.text.trim();
                        String cat = _taskCatController.text.trim();
                        String price =
                            int.parse(_taskpriceController.text).toString();
                        print(task);

                        _db
                            .collection("users")
                            .document(user.uid)
                            .collection("tasks")
                            .add({
                          "task": task,
                          "date": DateTime.now(),
                          "category": cat,
                          "description": desc,
                          "price": price
                        });

                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );
        });
  }
}
