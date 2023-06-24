// import 'dart:js_util';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ippl_miftah/screen/add_notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ippl_miftah/db/db.dart';
import 'package:ippl_miftah/model/notes.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum TtsState { playing, stopped, paused, continued }

class _HomeScreenState extends State<HomeScreen> {
  AudioPlayer player = AudioPlayer();
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.6;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future _getDefaultEngine() async => await flutterTts.getDefaultEngine;

  Future _getDefaultVoice() async => await flutterTts.getDefaultVoice;

  Future _speak(String text) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    _getDefaultEngine();
    _getDefaultVoice();

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(false);
  }

  DatabaseHelper databaseHelper = DatabaseHelper();
  late Note note;
  List<Note> noteList = [];
  int count = 0;
  @override
  void initState() {
    super.initState();
    updateListView();
    initTts();
    // databaseHelper.deleteDb();
    // databaseHelper.createDb();
  }

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty) {
      noteList = [];
      // updateListView();
    }

    void navigateToDetail(Note note, String title) async {
      bool result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddNotes(note, title)));

      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Please wait a moment if the sound cant be played')),
        );
        updateListView();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Helper'),
      ),
      body: noteList.isEmpty
          ? Container(
              color: const Color(0xFCCA43B),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Click on the add button to add a new note!'),
                ),
              ),
            )
          : Container(
              color: Color(0xFFB4B8C5),
              child: getNotesList(),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Note('', '', ''), 'Add Note');
          },
          tooltip: 'Add Note',
          child: const Icon(Icons.add)),
    );
  }

  Widget getNotesList() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 4 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          physics: const BouncingScrollPhysics(),
          itemCount: count,
          itemBuilder: (BuildContext context, int index) => Material(
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                splashColor: Color.fromARGB(128, 78, 78, 78),
                onTap: () async {
                  try {
                    await player.stop();
                    await flutterTts.stop();
                  } catch (e) {}
                  if (noteList[index].file.isEmpty) {
                    await _speak(noteList[index].description);
                  } else if (!noteList[index].file.isEmpty) {
                    try {
                      File file = await File(noteList[index].file);
                      await player.play(DeviceFileSource(file.path));
                    } catch (e) {
                      await _speak(noteList[index].description);
                    }
                  }
                },
                onLongPress: () {
                  databaseHelper.deleteNote(noteList[index].id);
                  updateListView();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Catatan berhasil dihapus')));
                },
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                              child: Text(
                                noteList[index].title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(noteList[index].description,
                                  maxLines: 2),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;

          void moveToLastScreen() {
            Navigator.pop(context, true);
          }

          void _save() async {
            moveToLastScreen();

            // if (note.id != null) {
            //   await helper.updateNote(note);
            // } else {
            await databaseHelper.insertNote(note);
            // }
          }

          void _delete() async {
            await databaseHelper.deleteNote(note.id);
            moveToLastScreen();
          }
        });
      });
    });
  }
}
