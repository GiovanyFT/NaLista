
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nalista/dominio/usuario.dart';
import 'package:nalista/telas/tela_principal.dart';
import 'package:nalista/util/nav.dart';
import 'package:nalista/util/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ControleTelaLogin {
  // Controles de edição do login e senha
  final controlador_login = TextEditingController();
  final controlador_senha = TextEditingController();

  // Controlador de formulário (para fazer validações)
  final formkey = GlobalKey<FormState>();

  // Controladores de foco
  final focus_senha = FocusNode();
  final focus_botao = FocusNode();

  // Autenticação
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _collection_usuarios => Firestore.instance.collection('usuarios');

  void logar(BuildContext context) async{
    if (formkey.currentState.validate()){
      String login = controlador_login.text.trim();
      String senha = controlador_senha.text.trim();

      // Logando
      try{
        AuthResult result = (await _auth.signInWithEmailAndPassword(email: login, password: senha));
        final FirebaseUser user = result.user;
        print("login ${user.email} ");
        _irParaTelaPrincipal(user, context);
      } catch (error){
        MensagemAlerta("Erro: Login inválido ou senha incorreta");
      }
    }
  }

  void _irParaTelaPrincipal(FirebaseUser user, BuildContext context) {
    // Buscando o usuário no serviço de armazenamento e chamando a tela Principal
    _collection_usuarios.
      where("email", isEqualTo: "${user.email}").snapshots().
      listen((data) {
        Usuario usuario = Usuario.fromMap(data.documents[0].data);
        usuario.id = data.documents[0].documentID;
        push(context, TelaPrincipal(usuario), replace: true);
      });
  }

  void cadastrar(BuildContext context) async{
    if (formkey.currentState.validate()){
      String login = controlador_login.text.trim();
      String senha = controlador_senha.text.trim();

      // Criando o usuário
      try{
        // No serviço de autenticação
        AuthResult result = (await _auth.createUserWithEmailAndPassword(email: login, password: senha));
        final FirebaseUser user = result.user;
        print("login ${user.email} ");
        // No serviço de armazenamento
        DocumentReference docRef = _collection_usuarios.document();
        Future<void> future = docRef.setData({'email': user.email});
        future.then( (value){
          _irParaTelaPrincipal(user, context);
        });
      } catch (error){
        MensagemAlerta("Erro: Não foi possível criar o usuário");
      }
    }
  }

}