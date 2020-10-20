
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:municipios/modelos/usuarios.dart';

class DbUsuarios
{

final DatabaseReference ref= FirebaseDatabase.instance.reference().child('usuarios');


Future userregister(String uid,String nom,String email,String rol) async
{
  
  return await ref.child(uid).set({
    "nombre": nom,
    "email": email,
    "rol":rol,
  });
  
  
}

Future<String> isAdmin(String uid) async
{
  String rol;
  print("DB");
  
  await ref.child(uid).child("rol").once().then((DataSnapshot snapshot) {

print("finish db");
    
    if(snapshot.value!=null)
    {
      print('Data : ${snapshot.value}');
    if(snapshot.value=="Administrador")
    {
      print('Data Admin : ${snapshot.value}');
      rol=snapshot.value.toString();
      return "Administrador";
    }else{
      print('Data General : ${snapshot.value}');
       rol=snapshot.value.toString();
      return "General";
    }
    }
  }
  );
  print(rol);
  return rol;

  
  
  
}

userdelete(String  usuario)
{
  final usuariosReference = FirebaseDatabase.instance.reference().child('usuarios');

  usuariosReference.child(usuario).remove();
 
}



}