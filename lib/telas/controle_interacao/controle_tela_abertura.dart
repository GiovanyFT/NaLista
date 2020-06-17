
import 'package:flutter/cupertino.dart';
import 'package:nalista/dominio/usuario.dart';
import 'package:nalista/telas/tela_login.dart';
import 'package:nalista/telas/tela_principal.dart';
import 'package:nalista/util/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ControleTelaAbertura{
  void inicializarAplicacao(BuildContext context) {


    // Dando um tempo para exibição da tela de abertura
    Future futureA = Future.delayed(Duration(seconds: 3));

    // Obtendo o usuário logado (se houver)
    Future<Usuario> futureB = Usuario.obter();

    // Obtendo o Usuário (caso já esteja logado)
    Future<FirebaseUser> futureC = FirebaseAuth.instance.currentUser();


    // Agurandando as 3 operações terminarem
    // Quando terminarem a aplicação ou vai para a tela de login
    // ou para a tela principal
    Future.wait([futureA, futureB, futureC]).then((List values) {
      FirebaseUser firebaseUser = values[2];
      if(firebaseUser == null)
        push(context, TelaLogin(), replace: true);
      else{
        Usuario usuario;
        Firestore.instance.collection('usuarios').
        where("email", isEqualTo: "${firebaseUser.email}").snapshots().
        listen((data) {
          usuario = Usuario.fromMap(data.documents[0].data);
          usuario.id = data.documents[0].documentID;
          push(context, TelaPrincipal(usuario), replace: true);

        });
      }
    });
  }
}
