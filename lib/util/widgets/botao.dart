import 'package:flutter/material.dart';

class Botao extends StatelessWidget {
  String texto;
  Function ao_clicar;
  FocusNode marcador_foco;
  Color cor;
  bool mostrar_progress;

  Botao(
      {this.texto,
      this.ao_clicar,
      this.marcador_foco,
      this.cor,
      this.mostrar_progress = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: RaisedButton(
        color: cor,
        child: mostrar_progress
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                texto,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
        onPressed: ao_clicar,
        focusNode: marcador_foco,
      ),
    );
  }
}
