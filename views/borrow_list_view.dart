import 'package:demo_firebase_setup/models/book_model.dart';
import 'package:demo_firebase_setup/models/borrow_info_model.dart';
import 'package:demo_firebase_setup/services/calculator.dart';
import 'package:demo_firebase_setup/views/add_book_view_model.dart';
import 'package:demo_firebase_setup/views/update_book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'borrow_list_view_model.dart';

class BorrowListView extends StatefulWidget {
  final Book book;
  const BorrowListView({this.book});

  @override
  _BorrowListViewState createState() => _BorrowListViewState();
}

class _BorrowListViewState extends State<BorrowListView> {
  @override
  Widget build(BuildContext context) {
    List<BorrowInfo> borrowList = widget.book.borrows;
    return ChangeNotifierProvider<BorrowListViewModel>(
      create: (context) => BorrowListViewModel(),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text('${widget.book.bookName} Ödünç Kayıtları'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: borrowList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            'https://cdn.kidega.com/author/large/carl-sagan-profil-ZB.jpg'),
                      ),
                      title: Text(
                          '${borrowList[index].name} ${borrowList[index].surname}'),
                    );
                  },
                  separatorBuilder: (context, _) => Divider(),
                ),
              ),
              InkWell(
                  onTap: () async {
                    BorrowInfo newBorrowInfo =
                        await showModalBottomSheet<BorrowInfo>(
                            builder: (BuildContext context) {
                              return BorrowForm();
                            },
                            context: context);
                    if (newBorrowInfo != null) {
                      setState(() {
                        borrowList.add(newBorrowInfo);
                      });
                      context.read<BorrowListViewModel>().updateBook(
                          book: widget.book, borrowList: borrowList);
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 80,
                      color: Colors.blueAccent,
                      child: Text(
                        'YENİ ÖDÜNÇ',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class BorrowForm extends StatefulWidget {
  @override
  _BorrowFormState createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController surnameCtr = TextEditingController();
  TextEditingController borrowDateCtr = TextEditingController();
  TextEditingController returnDateCtr = TextEditingController();
  DateTime _selectedBorrowDate;
  DateTime _selectedReturnDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameCtr.dispose();
    surnameCtr.dispose();
    borrowDateCtr.dispose();
    returnDateCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      child: Form(
        key: _formKey,
        child: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Stack(children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://cdn.kidega.com/author/large/carl-sagan-profil-ZB.jpg'),
                  ),
                  Positioned(
                    bottom: -5,
                    right: -10,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.photo_camera_rounded,
                          color: Colors.grey.shade100,
                          size: 26,
                        )),
                  )
                ]),
              ),
              Flexible(
                child: Column(
                  children: [
                    TextFormField(
                        controller: nameCtr,
                        decoration: InputDecoration(
                          hintText: 'Ad',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ad Giriniz';
                          } else {
                            return null;
                          }
                        }),
                    TextFormField(
                        controller: surnameCtr,
                        decoration: InputDecoration(
                          hintText: 'Soyad',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Soyadı Giriniz';
                          } else {
                            return null;
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TextFormField(
                    onTap: () async {
                      _selectedBorrowDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)));

                      borrowDateCtr.text =
                          Calculator.dateTimeToString(_selectedBorrowDate);
                    },
                    controller: borrowDateCtr,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.date_range),
                      hintText: 'Alım Tarihi',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen Tarih Seçiniz';
                      } else {
                        return null;
                      }
                    }),
              ),
              SizedBox(width: 10),
              Flexible(
                child: TextFormField(
                    onTap: () async {
                      _selectedReturnDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)));

                      returnDateCtr.text =
                          Calculator.dateTimeToString(_selectedReturnDate);
                    },
                    controller: returnDateCtr,
                    decoration: InputDecoration(
                        hintText: 'İade Tarihi',
                        prefixIcon: Icon(Icons.date_range)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen Tarih Seçiniz';
                      } else {
                        return null;
                      }
                    }),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  /// kulanıcı bilgileri ile BorrowInfo objesi oluşturacağız
                  BorrowInfo newBorrowInfo = BorrowInfo(
                      name: nameCtr.text,
                      surname: surnameCtr.text,
                      borrowDate:
                          Calculator.datetimeToTimestamp(_selectedBorrowDate),
                      returnDate:
                          Calculator.datetimeToTimestamp(_selectedBorrowDate));

                  /// navigator.pop
                  Navigator.pop(context, newBorrowInfo);
                }
              },
              child: Text('ÖDÜNÇ KAYIT EKLE'))
        ]),
      ),
    );
  }
}
