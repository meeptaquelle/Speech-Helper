import 'dart:io';

class Note {
  int? _id;
  String? _title;
  String? _description;
  String? _file;

  Note(this._title, this._description, this._file);

  Note.withId(this._id, this._title, this._description, this._file);

  int get id => _id ?? 0;
  String get title => _title ?? "";
  String get description => _description ?? "";
  String get file => _file ?? "";

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 65535) {
      _description = newDescription;
    }
  }

  set file(String newfile) {
    if (newfile.length <= 65535) {
      _file = newfile;
    }
  }
  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['file'] = _file;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _file = map['file'];
  }
}
