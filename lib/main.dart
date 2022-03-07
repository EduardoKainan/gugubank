import 'package:js/js.dart';
import 'package:js/src/varargs.dart';

import 'package:flutter/material.dart';

void main() => runApp(ByteBankApp());

class ByteBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.cyan[900], secondary: Colors.indigo[700])),
      home: ListadeTransferencias(),
    );
  }
}

class FormularioTransf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FormularioTransfState();
  }
}

class FormularioTransfState extends State<FormularioTransf> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 16.0));

  final TextEditingController _controladorCampoNunConta =
      TextEditingController();
  final TextEditingController _controladorCampoVlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Transferencia'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoNunConta,
              rotulo: 'Numero da Conta',
              dica: '0000',
              icone: Icons.countertops,
            ),
            Editor(
                controlador: _controladorCampoVlr,
                rotulo: 'valor',
                dica: '0.00',
                icone: Icons.monetization_on),
            ElevatedButton(
              style: style,
              child: const Text('Confirmar'),
              onPressed: () => criaTransferencia(context),
            )
          ],
        ),
      ),
    );
  }

  void criaTransferencia(BuildContext context) {
    final int nConta = int.parse(_controladorCampoNunConta.text);
    final double valorT = double.parse(_controladorCampoVlr.text);
    if (nConta != null && valorT != null) {
      final transferenciaCriada = Transferencia(valorT, nConta);
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;

  const Editor({
    Key? key,
    required this.controlador,
    required this.rotulo,
    required this.dica,
    required this.icone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListadeTransferencias extends StatefulWidget {
  final _transferencias = <Transferencia>[];

  @override
  State<ListadeTransferencias> createState() {
    return ListaTransferenciasState();
  }
}

class ListaTransferenciasState extends State<ListadeTransferencias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GuGuBank'),
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final Future future = Navigator.push<Transferencia>(context,
              MaterialPageRoute<Transferencia>(builder: (context) {
            return FormularioTransf();
          }));
          future.then((transferenciaRecebida) {
            Future.delayed(Duration(seconds: 1), () {
              debugPrint('$transferenciaRecebida');
              if (transferenciaRecebida != null) {
                setState(() {
                  //o setState e responsavel por chamar o builder, com os valores atualizados
                  //É nesse exato momento que a tranferencia é adicionada na lista e é nesse momento que a tela precisa ser atualizada
                  widget._transferencias.add(transferenciaRecebida);
                });
              }
            });
          });
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;
  ItemTransferencia(this._transferencia);
  //gerar construtor
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Icon(Icons.monetization_on),
      title: Text(_transferencia.valor.toString()),
      subtitle: Text(_transferencia.conta.toString()),
    ));
  }
}

class Transferencia {
  final double valor;
  final int conta;

  Transferencia(this.valor, this.conta);
  @override
  String toString() {
    // TODO: implement toString
    return 'Transferencia{valor: $valor, numeroConta: $conta}';
  }
}
