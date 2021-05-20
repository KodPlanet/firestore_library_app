import 'package:demo_firebase_setup/models/book_model.dart';
import 'package:demo_firebase_setup/services/calculator.dart';
import 'package:demo_firebase_setup/services/database.dart';
import 'package:flutter/material.dart';

class AddBookViewModel extends ChangeNotifier {
  Database _database = Database();
  String collectionPath = 'books';

  Future<void> addNewBook(
      {String bookName, String authorName, DateTime publishDate}) async {
    /// Form alanındaki verileri ile önce bir book objesi oluşturulması
    Book newBook = Book(
        id: DateTime.now().toIso8601String(),
        bookName: bookName,
        authorName: authorName,
        publishDate: Calculator.datetimeToTimestamp(publishDate));

    /// bu kitap bilgisini database servisi üzerinden Firestore'a yazacak
    await _database.setBookData(
        collectionPath: collectionPath, bookAsMap: newBook.toMap());
  }
}
