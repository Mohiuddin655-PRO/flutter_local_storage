library local_storage;

import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// A utility class for handling local storage operations.
class LocalStorage {
  const LocalStorage._();

  /// Singleton instance of [LocalStorage].
  static LocalStorage? _i;

  /// Get the singleton instance of [LocalStorage].
  static LocalStorage get i => _i ??= const LocalStorage._();

  /// Alias for [i].
  static LocalStorage get I => i;

  /// Alias for [i].
  static LocalStorage get instance => i;

  /// Retrieves the root directory path for local storage.
  ///
  /// Returns a [Future] that completes with the root directory path.
  Future<String> get root async {
    return getApplicationDocumentsDirectory().onError((_, __) {
      return Directory("");
    }).then((value) => value.path);
  }

  /// Constructs the full reference path based on the provided [path].
  ///
  /// Returns a [Future] that completes with the full reference path.
  Future<String> _ref(String path) => root.then((_) => '$_/$path');

  /// Constructs a [File] object based on the provided [path].
  ///
  /// Returns a [Future] that completes with the [File] object.
  Future<File> _file(String path) => _ref(path).then((_) => File(_));

  /// Saves the provided [bytes] as a file with the specified [filename].
  ///
  /// Returns a [Future] that completes with the saved file path.
  Future<String> saveAsBytes(String filename, List<int> bytes) async {
    try {
      final file = await _file(filename);
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (_) {
      try {
        return _ref(filename);
      } catch (__) {
        return "";
      }
    }
  }

  /// Saves the provided [file] with the specified [filename].
  ///
  /// Returns a [Future] that completes with the saved file path.
  Future<String> save(String filename, File file) {
    return saveAsBytes(filename, file.readAsBytesSync());
  }

  /// Retrieves the reference path for the specified [filename].
  ///
  /// Returns a [Future] that completes with the reference path or `null` if an error occurs.
  Future<String?> reference(String filename) async {
    try {
      return _ref(filename);
    } catch (_) {
      return null;
    }
  }

  /// Loads the file with the specified [filename].
  ///
  /// Returns a [Future] that completes with the loaded [File] or `null` if the file does not exist.
  Future<File?> load(String filename) async {
    try {
      final file = await _file(filename);
      if (await file.exists()) {
        return file;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  /// Loads the file at the specified [path].
  ///
  /// Returns a [Future] that completes with the loaded [File] or `null` if the file does not exist.
  Future<File?> loadByPath(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return file;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  /// Deletes the file with the specified [filename].
  ///
  /// Returns a [Future] that completes once the file is deleted.
  Future<void> delete(String filename) async {
    final file = await _file(filename);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Deletes the file at the specified [path].
  ///
  /// Returns a [Future] that completes once the file is deleted.
  Future<void> deleteByPath(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Check the file with the specified [filename]
  ///
  /// Returns a [Future] that completes once the file is existed
  Future<bool> isExisted(String filename) async {
    final file = await _file(filename);
    return file.exists();
  }
}
