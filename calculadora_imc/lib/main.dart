import 'package:flutter/material.dart';

void main() => runApp(CalculadoraIMCApp());

class CalculadoraIMCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.teal,
        cardColor: Colors.grey[900],
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelStyle: TextStyle(color: Colors.white70),
          prefixIconColor: Colors.tealAccent,
        ),
      ),
      home: CalculadoraIMC(),
    );
  }
}

class CalculadoraIMC extends StatefulWidget {
  @override
  _CalculadoraIMCState createState() => _CalculadoraIMCState();
}

class _CalculadoraIMCState extends State<CalculadoraIMC> {
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  String resultado = "";
  String classificacao = "";
  String generoSelecionado = "Masculino";
  List<double> historicoIMC = [];

  void calcularIMC() {
    final peso = double.tryParse(pesoController.text);
    final alturaCm = double.tryParse(alturaController.text);

    if (peso == null || alturaCm == null || alturaCm == 0) {
      setState(() {
        resultado = "Por favor, insira valores válidos.";
        classificacao = "";
      });
      return;
    }

    final alturaM = alturaCm / 100;
    final imc = peso / (alturaM * alturaM);

    String classificacaoLocal;
    if (imc < 18.5) {
      classificacaoLocal = "Abaixo do peso";
    } else if (imc < 25) {
      classificacaoLocal = "Peso normal";
    } else if (imc < 30) {
      classificacaoLocal = "Sobrepeso";
    } else {
      classificacaoLocal = "Obesidade";
    }

    setState(() {
      resultado = "IMC: ${imc.toStringAsFixed(1)}";
      classificacao = classificacaoLocal;
      historicoIMC.add(imc);
    });
  }

  Widget buildHistorico() {
    if (historicoIMC.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Histórico de IMC", style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        ...historicoIMC.reversed.map((imc) => Text("• ${imc.toStringAsFixed(1)}")).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Gênero", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Row(children: [Icon(Icons.male), SizedBox(width: 5), Text("Masculino")]),
                  selected: generoSelecionado == "Masculino",
                  onSelected: (_) => setState(() => generoSelecionado = "Masculino"),
                  selectedColor: Colors.teal,
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Row(children: [Icon(Icons.female), SizedBox(width: 5), Text("Feminino")]),
                  selected: generoSelecionado == "Feminino",
                  onSelected: (_) => setState(() => generoSelecionado = "Feminino"),
                  selectedColor: Colors.pink,
                ),
              ],
            ),
            SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: pesoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Peso (kg)",
                        prefixIcon: Icon(Icons.monitor_weight_outlined),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: alturaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Altura (cm)",
                        prefixIcon: Icon(Icons.height_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: calcularIMC,
              icon: Icon(Icons.calculate),
              label: Text("Calcular seu IMC", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 30),
            if (resultado.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("Gênero: $generoSelecionado", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text(resultado, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(classificacao, style: TextStyle(fontSize: 22, color: Colors.orangeAccent)),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),
            buildHistorico(),
          ],
        ),
      ),
    );
  }
}