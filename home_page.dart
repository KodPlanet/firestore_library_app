import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference moviesRef = _firestore.collection('movies');
    var babaRef = moviesRef.doc('Baba');

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text('Firestore CRUD İşlemleri')),
      body: Center(
        child: Container(
          child: Column(
            children: [
              /*ElevatedButton(
                child: Text('GET QUERYSNAPSHOT'),
                onPressed: () async {
                  var response = await moviesRef.get();

                  var list = response.docs;

                  /// QuerySnaphot ??
                  ///
                  /// List içinde neler var?
                  print(list[2].data());
                },
              ),*/
              StreamBuilder<QuerySnapshot>(
                /// Neyi dinlediğimiz bilgisi, hangi streami
                stream: moviesRef.snapshots(),

                /// Streamden her yerni veri aktığında, aşağıdaki metodu çalıştır
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Center(
                        child: Text('Bir Hata Oluştu, Tekrar Deneynizi'));
                  } else {
                    if (asyncSnapshot.hasData) {
                      List<DocumentSnapshot> listOfDocumentSnap =
                          asyncSnapshot.data.docs;
                      return Flexible(
                        child: ListView.builder(
                          itemCount: listOfDocumentSnap.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(
                                    '${listOfDocumentSnap[index].data()['name']}',
                                    style: TextStyle(fontSize: 24)),
                                subtitle: Text(
                                    '${listOfDocumentSnap[index].data()['rating']}',
                                    style: TextStyle(fontSize: 16)),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await listOfDocumentSnap[index]
                                        .reference
                                        .delete();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 200),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration:
                            InputDecoration(hintText: 'Film Adını Giriniz'),
                      ),
                      TextFormField(
                        controller: ratingController,
                        decoration: InputDecoration(hintText: 'Rating Giriniz'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('Ekle'),
        onPressed: () async {
          print(nameController.text);
          print(ratingController.text);

          /// Text alanlarındaki veriden bir map oluşturulması
          Map<String, dynamic> movieData = {
            'name': nameController.text,
            'rating': ratingController.text
          };

          /// Veriyi yazmak istediğimiz refeansa ulaşacağız ve ilgili metodu çağıracağız
          await moviesRef.doc(nameController.text).update({'year': '2012'});
        },
      ),
    );
  }
}
