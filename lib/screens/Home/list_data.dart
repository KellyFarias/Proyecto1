import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  DatabaseReference _municipioRef;

  /// The page title.
  ListPage({this.app});
  final FirebaseApp app;
  //final String title = 'Sign In & Out';

  @override
  State<StatefulWidget> createState() => _ListPage();
}

class _ListPage extends State<ListPage> {
  int _counter;
  DatabaseReference _municipiosRef;
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;

  @override
  void initState() {
    super.initState();
    // Demonstrates configuring to the database using a file
    //_counterRef = FirebaseDatabase.instance.reference().child('counter');
    // Demonstrates configuring the database directly
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _municipiosRef = database.reference().child('municipios');
    database.reference().child('counter').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    _messagesSubscription =
        _municipiosRef.limitToLast(10).onChildAdded.listen((Event event) {
      print('Child added: ${event.snapshot.value}');
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  bool _anchorToBottom = false;
  String munClave,
      munNombre,
      munSignificado,
      munCabecera,
      munSuperficie,
      munAltitud,
      munAspectos;
  DatabaseError _error;

  /* @override
  void initState() {
    super.initState();
    // Demonstrates configuring to the database using a file
    //_counterRef = FirebaseDatabase.instance.reference().child('municipios');
    // Demonstrates configuring the database directly
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _municipiosRef= database.reference().child('municipios');
    database.reference().child('counter').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }*/

  @override
  void dispose() {
    super.dispose();
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }

  Future<void> _increment() async {
    // Increment counter in transaction.
    final TransactionResult transactionResult =
        await _municipiosRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;
      return mutableData;
    });

    if (transactionResult.committed) {
      //_messagesRef.push().set(<String, String>{'Usuario': _kTestKey});
      _municipiosRef.push().set(<String, String>{
        'Clave': munClave,
        'Nombre': munNombre,
        'Significado': munSignificado,
        'Cabecera Municipal': munCabecera,
        'Superficie': munSuperficie,
        'Altitud': munAltitud,
        'Principales Aspectos': munAspectos
      });
      //municipios.push().set(<String, String>{'Usuario': munNombre});
      //_usersRef.push().set(<String, String>{'hola': 'mundo'});
      //_usersRef.update(<String, String>{'MJQDQoZ2dh4eiKrDVZ2': 'world'});
      //_usersRef.update(<String, String>{'adios2': 'world2'});
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Database Example'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Center(
              child: Text('Ingrese los datos del municipio'),
            ),
          ),
          Flexible(
            child: FirebaseAnimatedList(
              key: ValueKey<bool>(_anchorToBottom),
              query: _municipiosRef,
              reverse: _anchorToBottom,
              sort: _anchorToBottom
                  ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
                  : null,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () => _municipiosRef
                          .child(snapshot.key)
                          .update(
                              <String, String>{'Usuario': 'Sustituir AQUI'}),
                      icon: Icon(Icons.edit),
                    ),
                    trailing: IconButton(
                      onPressed: () =>
                          _municipiosRef.child(snapshot.key).remove(),
                      icon: Icon(Icons.delete),
                    ),

                    //.update(<String, String>{'Usuario': _kTestKey}),

                    title: Text(
                      snapshot.value.toString(),
                      //"${snapshot.value}sd",
                    ),
                  ),
                );
              },
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Clave",
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.pink),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
            cursorColor: Colors.purple,
            cursorRadius: Radius.circular(16.0),
            cursorWidth: 16.0,
            onChanged: (texto) {
              munClave = texto;
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Nombre",
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.pink),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
            cursorColor: Colors.purple,
            cursorRadius: Radius.circular(16.0),
            cursorWidth: 16.0,
            onChanged: (texto) {
              munNombre = texto;
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Significado",
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.pink),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
            cursorColor: Colors.purple,
            cursorRadius: Radius.circular(16.0),
            cursorWidth: 16.0,
            onChanged: (texto) {
              munSignificado = texto;
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Cabecera Municipal",
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.pink),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
            cursorColor: Colors.purple,
            cursorRadius: Radius.circular(16.0),
            cursorWidth: 16.0,
            onChanged: (texto) {
              munCabecera = texto;
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Superficie",
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.pink),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
            cursorColor: Colors.purple,
            cursorRadius: Radius.circular(16.0),
            cursorWidth: 16.0,
            onChanged: (texto) {
              munSuperficie = texto;
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Altitud",
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.pink),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
            cursorColor: Colors.purple,
            cursorRadius: Radius.circular(16.0),
            cursorWidth: 16.0,
            onChanged: (texto) {
              munAltitud = texto;
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Principales Aspectos",
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.pink),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
            cursorColor: Colors.purple,
            cursorRadius: Radius.circular(16.0),
            cursorWidth: 16.0,
            onChanged: (texto) {
              munAspectos = texto;
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: _increment,
        //tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}