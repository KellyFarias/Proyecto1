import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:municipios/modelos/municipio.dart';
import 'package:municipios/screens/Home/Administrador/municipio_information.dart';
import 'package:municipios/screens/Home/Administrador/municipio_screen.dart';
import 'package:municipios/screens/Home/googlemap.dart';

import '../../../modelos/municipio.dart';

class ListViewMunicipiosAdmin extends StatefulWidget {
  @override
  _ListViewMunicipiosAdminState createState() => _ListViewMunicipiosAdminState();
}

final municipioReference = FirebaseDatabase.instance.reference().child('municipios');
final riesgoReference = FirebaseDatabase.instance.reference().child('riesgos');

class _ListViewMunicipiosAdminState extends State<ListViewMunicipiosAdmin> {
  List<Municipios> items;
 
  StreamSubscription<Event> _onMunicipiosAddSusc;
  StreamSubscription<Event> _onMunicipiosEditSusc;
  final key = GlobalKey<ScaffoldState>();
  TextEditingController editingController=TextEditingController();
 
  @override
  void initState() {
    
    items = new List();
    
    _onMunicipiosAddSusc =
        municipioReference.onChildAdded.listen(_onMunicipioAdded);
    _onMunicipiosEditSusc =
        municipioReference.onChildChanged.listen(_onMunicipioEdit);
        
        super.initState(); 
    
      }
    
      @override
      void dispose() {
        super.dispose();
        _onMunicipiosAddSusc.cancel();
        _onMunicipiosEditSusc.cancel();
      }
    
      @override
      Widget build(BuildContext context) {
        return new Scaffold(
      appBar: new AppBar(
        title: new Text('MUNICIPIOS'),
      ),
      drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text('Drawer header'),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                    ),
                    ),
                    ListTile(
                      title: Text('Busqueda por Municipio'),
                      onTap:(){
                         },
                    ),
                    ListTile(
                      title: Text('Busqueda por Zona de Riesgo'),
                      onTap:(){
                      },
                    ),
                ],
              ),
            ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, position) {
                    if (editingController.text.isEmpty) {
                    return Column(
                      children: <Widget>[
                         Divider(
                          height: 1.0,
                        ),                    
                        Container(
                          padding: new EdgeInsets.all(3.0),
                          child: Card(                      
                            child: Row(
                              children: <Widget>[
                                 IconButton(
                                    icon: Icon(
                                      Icons.location_on ,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: ()
                                    {
                                       
                               }),
                               Expanded(
                                  child: ListTile(
                                      title: Text(
                                        '${items[position].nombre}',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 21.0,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${items[position].significado}',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 21.0,
                                        ),
                                      ),
                                      onTap: () => _navigateToMunicipioInformation(
                                          context, items[position]),),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _showDialog(context, position),
                                    ),
                                    
                                //onPressed: () => _deleteProduct(context, items[position],position)),
                                IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () =>
                                        _navigateToMunicipio(context, items[position])),
                              ],
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                    } else if (items[position]
                            .nombre
                            .toLowerCase()
                            .contains(editingController.text.toLowerCase())) {
                       return Column(
                      children: <Widget>[
                         Divider(
                          height: 1.0,
                        ),                    
                        Container(
                          padding: new EdgeInsets.all(3.0),
                          child: Card(                      
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () =>
                                        _navigateToMunicipio(context, items[position])),
                                Expanded(
                                  child: ListTile(
                                      title: Text(
                                        '${items[position].nombre}',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 21.0,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${items[position].significado}',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 21.0,
                                        ),
                                      ),
                                      onTap: () => _navigateToMunicipioInformation(
                                          context, items[position]),),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _showDialog(context, position),
                                    ),
                                IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () =>
                                        _navigateToMunicipio(context, items[position])),
                                 
                              ],
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                    } else {
                      return Container();
                    }
                    
                  }
                  ),
                  
            ),
            
            
          ],

        ),
        
      ),
       floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.pinkAccent,
              onPressed: () => _createNewMunicipio(context),
            ),
          );
       
      }
    
       //nuevo para que pregunte antes de eliminar un registro


     
       
      void _showDialog(context, position) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text('Are you sure you want to delete this item?'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.purple,
                    ),
                    onPressed: () =>
                      _deleteMunicipio(context, items[position], position,),                                        
                         ),                   
                new FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    
      void _onMunicipioAdded(Event event) {
        setState(() {
          items.add(new Municipios.fromSnapShot(event.snapshot));
        });
      }

      void _onSearchByMunicipio(String municip) {
        setState(() {
          municipioReference.child('nombre').equalTo(municip).once().then((DataSnapshot snapshot)
          {
            items.clear();
            items.add(new Municipios.fromSnapShot(snapshot));
          });
         
        });
      }
      void _onSearchByZonaRiesgo(Event event,String clave) {
        setState(() {
          riesgoReference.child('clave').equalTo(clave).once().then((DataSnapshot snapshot1)
          {
            municipioReference.child(snapshot1.value.clave).equalTo(clave).once().then((DataSnapshot snapshot2)
          {
            items.clear();
            items.add(new Municipios.fromSnapShot(snapshot2));
          });

           
          });
         
        });
      }
      
      
    
      void _onMunicipioEdit(Event event) {
        var oldMunicipioValue =
            items.singleWhere((municipios) => municipios.clave == event.snapshot.key);
        setState(() {
          items[items.indexOf(oldMunicipioValue)] =
              new Municipios.fromSnapShot(event.snapshot);
        });
      }
    
      void _deleteMunicipio(
          BuildContext context, Municipios municipios, int position) async {
        await municipioReference.child(municipios.clave).remove().then((_) {
          setState(() {
            items.removeAt(position);
            Navigator.of(context).pop();
          });
        });
      }
    
      void _navigateToMunicipioInformation(
          BuildContext context, Municipios municipios) async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MunicipioScreen(municipios)),
        );
      }
      void _navigateToMap(
          BuildContext context, String lat,String long) async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyGooglePage(muMunicipion: '{municipios}',)),
        );
      }
    
      void _navigateToMunicipio(BuildContext context, Municipios municipios) async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MunicipioInfomation(municipios)),
        );
      }
    
      void _createNewMunicipio(BuildContext context) async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MunicipioScreen(Municipios(null,'', '','', '', '', '', '', '','' , '', '', '', '', '', ''))),
        );
      }
}