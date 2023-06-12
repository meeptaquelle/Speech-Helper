import 'package:flutter/material.dart';
import 'package:ippl_miftah/screen/add_notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ippl_miftah/db/db.dart';
import 'package:ippl_miftah/model/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = [];
  int count = 0;

  final List<Map> myProducts =
      List.generate(100000, (index) => {"id": index, "name": "Product $index"});

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty) {
      noteList = [];
      updateListView();
    }

    void navigateToDetail(Note note, String title) async {
      bool result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddNotes(note, title)));

      if (result == true) {
        updateListView();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('kontolodon awikwok'),
      ),
      body: noteList.isEmpty
          ? Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Click on the add button to add a new note!'),
                ),
              ),
            )
          : Container(
              color: Colors.white,
              child: getNotesList(),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Note('', ''), 'Add Note');
          },
          tooltip: 'Add Note',
          child: const Icon(Icons.add)),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Kindacode.com'),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     // implement GridView.builder
    //     child: GridView.builder(
    //         gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    //             maxCrossAxisExtent: 200,
    //             childAspectRatio: 3 / 2,
    //             crossAxisSpacing: 20,
    //             mainAxisSpacing: 20),
    //         itemCount: myProducts.length,
    //         itemBuilder: (BuildContext ctx, index) {
    //           return GestureDetector(
    //             onTap: () {},
    //             child: Container(
    //               alignment: Alignment.center,
    //               decoration: BoxDecoration(
    //                   color: Colors.amber,
    //                   borderRadius: BorderRadius.circular(15)),
    //               child: Text(myProducts[index]["name"]),
    //             ),
    //           );
    //         }),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => const AddNotes()));
    //     },
    //     child: const Icon(Icons.add),
    //   ),
    // );
  }

  Widget getNotesList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          noteList[index].title,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(noteList[index].description),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
