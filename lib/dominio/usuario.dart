

import 'dart:convert';

import 'package:nalista/util/prefs.dart';



class Usuario {
  String id;
  String email;



  @override
  String toString() {
    return 'Usuario{id: $id, email: $email}';
  }

  Usuario.fromMap(Map<String, dynamic> map) {
    email = map["email"];

  }

  Map<String, dynamic> toMap(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = this.email;

    return data;
  }

  static void limpar(){
    // Limpando o usuário em Shared Preferences
    Prefs.setString("user.prefs", "");
  }

  // Salvando o usuário em Shared Preferences
  void salvar(){
    // Transformando o usuário em map
    Map usuario_map = this.toMap();

    // Transformando a map em String
    String usuario_string = json.encode(usuario_map);

    // Armazenando o usuário em Shared Preferences
    Prefs.setString("user.prefs", usuario_string);
  }

  static Future<Usuario> obter() async{
    String usuario_string = await Prefs.getString("user.prefs");
    if (usuario_string.isEmpty){
      return null;
    }

    Map usuario_map = json.decode(usuario_string);

    Usuario usuario = Usuario.fromMap(usuario_map);
    return usuario;
  }

}