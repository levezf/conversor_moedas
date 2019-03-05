import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=da2e0139";

void main() => runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
    ));

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final TextEditingController realController = TextEditingController();
  final TextEditingController dolarController = TextEditingController();
  final TextEditingController euroController = TextEditingController();

  double euro;
  double dolar;

  void _euroChange(String text){
    if(text.isNotEmpty) {
      double euro = double.parse(text);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
      realController.text = ((euro * this.euro)).toStringAsFixed(2);
    }else{
      dolarController.text = "";
      realController.text ="";
    }
  }
  void _realChange(String text){
    if(text.isNotEmpty) {
      double real = double.parse(text);
      dolarController.text = (real/dolar).toStringAsFixed(2);
      euroController.text = (real/euro).toStringAsFixed(2);
    }else{
      dolarController.text = "";
      euroController.text ="";
    }
  }
  void _dolarChange(String text){
    if(text.isNotEmpty) {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    }else{
      euroController.text = "";
      realController.text ="";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        centerTitle: true,
        title:
            Text('Conversor de Moedas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Carregando...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erro ao carregar os dados!",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center),
                  );
                } else {
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 125.0, color: Colors.amber),
                        buildTextField("Reais","R\$ ", realController, _realChange),
                        Divider(),
                        buildTextField("Dólares","US\$ ",dolarController, _dolarChange),
                        Divider(),
                        buildTextField("Euros", "€ ", euroController, _euroChange)
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function f){
  return TextField(
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    controller: controller,
    keyboardType: TextInputType.number,
    onChanged: f,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: label,
        labelText: label,
        prefixText: prefix),
  );
}
