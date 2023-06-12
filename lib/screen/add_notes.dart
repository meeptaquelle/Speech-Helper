import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ippl_miftah/db/db.dart';
import 'package:ippl_miftah/model/notes.dart';
import 'package:sqflite/sqflite.dart';

class AddNotes extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const AddNotes(this.note, this.appBarTitle, {super.key});

  @override
  State<StatefulWidget> createState() {
    return AddNotesState(this.note, this.appBarTitle);
  }
}

class AddNotesState extends State<AddNotes> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdited = false;

  AddNotesState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
        onWillPop: () async {
          isEdited ? showDiscardDialog(context) : moveToLastScreen();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(appBarTitle),
            leading: IconButton(
                splashRadius: 22,
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  isEdited ? showDiscardDialog(context) : moveToLastScreen();
                }),
            actions: <Widget>[
              IconButton(
                splashRadius: 22,
                icon: const Icon(
                  Icons.save,
                  color: Colors.black,
                ),
                onPressed: () {
                  titleController.text.isEmpty
                      ? showEmptyTitleDialog(context)
                      : _save();
                },
              ),
              IconButton(
                splashRadius: 22,
                icon: const Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  showDeleteDialog(context);
                },
              )
            ],
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: titleController,
                    maxLength: 255,
                    style: Theme.of(context).textTheme.bodyText2,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Title',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      maxLength: 255,
                      controller: descriptionController,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Description',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Discard Changes?"),
          content: Text("Are you sure you want to discard changes?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void showEmptyTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Title is empty!"),
          content: Text('The title of the note cannot be empty.'),
          actions: <Widget>[
            TextButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Delete Note?"),
          content: Text("Are you sure you want to delete this note?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
            ),
          ],
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  void updateDescription() {
    isEdited = true;
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    // if (note.id != null) {
    //   await helper.updateNote(note);
    // } else {
      await helper.insertNote(note);
    // }
  }

  void _delete() async {
    await helper.deleteNote(note.id);
    moveToLastScreen();
  }
}
