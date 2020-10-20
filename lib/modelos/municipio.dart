import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';

class Municipios{

String _clave;
String _nombre;
String _significado;
String _cabecera;
String _superficie;
String _altitud;
String _elevacion;
String _riocanal;
String _cuerpoagua;
String _maspoblado;
String _masextenso;
String _menospoblado;
String _industrializado;
String _clima;
String _longitud;
String _latitud;
  

Municipios(this._clave,this._nombre,this._significado,this._cabecera,
this._superficie,this._altitud,this._elevacion,this._riocanal,this._cuerpoagua,
this._maspoblado,this._masextenso,this._menospoblado,this._industrializado
,this._clima,this._latitud,this._longitud);

Municipios.map(dynamic obj)
{
  this._nombre=obj['nombre'];
  this._significado=obj['significado'];
  this._cabecera=obj['cabecera'];
  this._superficie=obj['superficie'];
  this._altitud=obj['altitud'];
  this._elevacion=obj['elevacion'];
  this._riocanal=obj['riocanal'];
  this._cuerpoagua=obj['cuerpoagua'];
  this._maspoblado=obj['maspoblado'];
  this._masextenso=obj['masextenso'];
  this._menospoblado=obj['menospoblado'];
  this._industrializado=obj['industrializado'];
  this._clima=obj['clima'];
  this._latitud=obj['latitud'];
  this._longitud=obj['longitud'];
}
  String get clave  => _clave;
  String get nombre =>_nombre;
  String  get significado => _significado;
  String get cabecera => _cabecera;
  String get superficie => _superficie;
  String get altitud => _altitud;
  String get elevaion => _elevacion;
  String get riocanal => _riocanal;
  String get cuerpoagua => _cuerpoagua;
  String get maspoblado =>  _maspoblado;
  String get masextenso => _masextenso;
  String get menospoblado => _menospoblado;
  String get industrializado => _industrializado;
  String get clima => _clima;
  String get longitud => _longitud;
  String get latitud => _latitud;

  Municipios.fromSnapShot(DataSnapshot snapshot)
  {
    
    _clave=snapshot.key;
    _nombre=snapshot.value['nombre'];    
    _significado=snapshot.value['significado'];
    _cabecera=snapshot.value['cabecera'];
    _superficie=snapshot.value['superficie'];
    _altitud=snapshot.value['altitud'];
    _elevacion=snapshot.value['elevacion'];
    _riocanal=snapshot.value['riocanal'];
    _cuerpoagua=snapshot.value['cuerpoagua'];
    _maspoblado=snapshot.value['maspoblado'];
    _masextenso=snapshot.value['masextenso'];
    _menospoblado=snapshot.value['menospoblado'];
    _industrializado=snapshot.value['industrializado'];
    _clima=snapshot.value['clima'];
    _latitud=snapshot.value['latitud'];
    _longitud=snapshot.value['longitud'];

  }


}