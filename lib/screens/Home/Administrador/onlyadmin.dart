import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:municipios/modelos/municipio.dart';
import 'package:municipios/screens/Home/Administrador/municipio_information.dart';
import 'package:municipios/screens/Home/Administrador/municipio_screen.dart';

import '../../../modelos/municipio.dart';

class ListViewMunicipiosAdmin extends StatefulWidget {
  @override
  _ListViewMunicipiosAdminState createState() => _ListViewMunicipiosAdminState();
}

final municipioReference = FirebaseDatabase.instance.reference().child('municipios');
final riesgoReference = FirebaseDatabase.instance.reference().child('riesgos');

class _ListViewMunicipiosAdminState extends State<ListViewMunicipiosAdmin> {
  List<Municipios> items;
  List<Municipios> visibleitems;
  StreamSubscription<Event> _onMunicipiosAddSusc;
  StreamSubscription<Event> _onMunicipiosEditSusc;
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQueryController = TextEditingController();
  String munselect="all";
  bool seach=false;
  @override
  void initState() {
    
    items = new List();
    _onMunicipiosAddSusc =
        municipioReference.onChildAdded.listen(_onMunicipioAdded);
    _onMunicipiosEditSusc =
        municipioReference.onChildChanged.listen(_onMunicipioEdit);
        super.initState(); 
    
    _searchQueryController.addListener(onChange);
        
      filter();
      }
    
      @override
      void dispose() {
        super.dispose();
        _onMunicipiosAddSusc.cancel();
        _onMunicipiosEditSusc.cancel();
      }
    
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text('Municipios List'),
              centerTitle: true,
              backgroundColor: Colors.pinkAccent,          
            ),
            body: Center(
              child: ListView.builder(
                  itemCount: items.length,
                  padding: EdgeInsets.only(top: 3.0),
                  itemBuilder: (context, position) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 110.0,),
                        Padding(
                          padding: EdgeInsets.only(left: 12.0,right: 12.0),
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            child: TextField(
                              onChanged: (changed){
                                setState(() => munselect=changed);
                              },
                              controller: _searchQueryController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.purple,
                                  size: 25.0),
                                  contentPadding: EdgeInsets.only(left: 10.0,top: 12.0),
                                  hintText: 'Busca Municipio',
                                  hintStyle: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Arial'
    
                                  )
                              ),
                            ),
                          ),
                          ),
                        
                        Divider(
                          height: 1.0,
                        ),                    
                        Container(
                          padding: new EdgeInsets.all(3.0),
                          child: Card(                      
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(
                                      title: Text(
                                        '${visibleitems[position].nombre}',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 21.0,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${visibleitems[position].significado}',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 21.0,
                                        ),
                                      ),
                                      onTap: () => _navigateToMunicipioInformation(
                                          context, items[position])),
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
                  }),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.pinkAccent,
              onPressed: () => _createNewMunicipio(context),
            ),
          ),
        );
      }
    
      void filter()
      {
        //setState
        List<Municipios> tmp;
        visibleitems.clear();
        String name=_searchQueryController.text;
        print(name + "Municipio slected");
        if(name.isEmpty)
        {
          tmp.addAll(items);

        }
        else{
          for(Municipios m in items)
          {
            if(m.nombre.toLowerCase().contains(name.toLowerCase()))
            {
              tmp.add(m);
            }
          }
        }
        visibleitems=tmp;
      
      }   //nuevo para que pregunte antes de eliminar un registro
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
      void _onSearchByMunicipio(Event event,String municip) {
        setState(() {
          municipioReference.child('nombre').equalTo(municip).once().then((DataSnapshot snapshot)
          {
            items.add(new Municipios.fromSnapShot(snapshot));
          });
         
        });
      }
      void _onSearchByZonaRiesgo(Event event,String clave) {
        setState(() {
          riesgoReference.child('clave').equalTo(clave).once().then((DataSnapshot snapshot)
          {
            items.add(new Municipios.fromSnapShot(snapshot));
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
    
      
    
      void onChange() {
        setState(() {
          
        });
  }
}