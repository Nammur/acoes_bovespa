import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const requestBovespa = "https://api.hgbrasil.com/finance/stock_price?key=ab189558&symbol=  ";

void main() async{

  print(await getData("CORR4"));

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Color.fromRGBO(240, 240, 242, 100),
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(240, 240, 242, 100))),
        hintStyle: TextStyle(color: Color.fromRGBO(240, 240, 242, 100)),
      )),
    ));
}

Future<Map> getData(String symbol) async{
  http.Response response = await http.get(requestBovespa + symbol);
  return json.decode(response.body);
}



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final symbolController = TextEditingController(); 
  final valorController = TextEditingController();

  String valor;
  String moeda = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(170, 177, 191, 100),
      appBar: AppBar(
        title: Text("Ações Bovespa"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Padding(padding: EdgeInsets.all(20)),
          TextField (
            controller: symbolController,
            decoration: InputDecoration(
              labelText: "Símbolo",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),  
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ) ,
            keyboardType: TextInputType.text,
          ),
          Padding(padding: EdgeInsets.all(20)),
          RaisedButton(
            child: Text("Pesquisar"),
            onPressed: () async{
                Map conteudo = await getData(symbolController.text);
                moeda = conteudo["results"][symbolController.text.toUpperCase()]["currency"].toString();
                valorController.text =moeda + " " + conteudo["results"][symbolController.text.toUpperCase()]["price"].toString();
                
            },
          ),
          Padding(padding: EdgeInsets.all(20)),
          TextField(
            readOnly: true,
            controller: valorController,
            decoration: InputDecoration(
              labelText: "Valor",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ) ,
          )
        ])
      )
    );
  }
}
