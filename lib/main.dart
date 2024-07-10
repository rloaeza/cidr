import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ip.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CIDR',
      home: CIDR(title: 'CIDR'),
    );
  }
}

class CIDR extends StatefulWidget {
  const CIDR({super.key, required this.title});

  final String title;

  @override
  State<CIDR> createState() => _CIDRState();
}

class _CIDRState extends State<CIDR> {
  String strIP = "";
  String strMascara = "";
  String strTamRed = "";
  late IP direccionIP;
  late TextEditingController dirIP, mascaraSubRed, tamRed;
  bool primeraCorrida = true;

  @override
  Widget build(BuildContext context) {
    dirIP = TextEditingController(text: strIP);
    mascaraSubRed = TextEditingController(text: strMascara);
    tamRed = TextEditingController(text: strTamRed);

    direccionIP = IP(dirIP.text, mascaraSubRed.text, tamRed.text);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          children: <Widget>[
            Card(
                child: Column(
              children: [
                entrada("Dirección IP",
                    hint: "192.168.1.1",
                    controller: dirIP,
                    onSubmitted: calcularDesdeEntradaTexto),
                entrada("Máscara de subred",
                    hint: "255.255.255.0",
                    controller: mascaraSubRed,
                    onSubmitted: calcularDesdeEntradaTexto),
                entrada("Tamaño de red",
                    hint: "# de dispositivos dentro de la red",
                    controller: tamRed,
                    onSubmitted: calcularDesdeEntradaTexto),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          strIP = "";
                          strMascara = "";
                          strTamRed = "";
                          primeraCorrida = true;
                          setState(() {
                            FocusManager.instance.primaryFocus?.unfocus();
                          });
                        },
                        child: const Text("Limpiar")),
                    ElevatedButton(
                        onPressed: () {
                          calcular();
                        },
                        child: const Text("Calcular")),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            )),
            const SizedBox(
              height: 30,
            ),
            if (!primeraCorrida && direccionIP.error)
              Expanded(
                child: Center(
                  child: Text(
                    direccionIP.errorTXT,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            if (!direccionIP.error)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Máscara de subred nueva"),
                  RichText(
                    text: TextSpan(
                      text: "",
                      children: [
                        TextSpan(
                            text: direccionIP
                                .mascaraPunteadaBinaria()
                                .substring(
                                    0,
                                    direccionIP.nBitsMascaraInicial +
                                        (direccionIP.nBitsMascaraInicial / 8)
                                            .floor()),
                            style:
                                GoogleFonts.sourceCodePro(color: Colors.blue)),
                        TextSpan(
                            text: direccionIP
                                .mascaraPunteadaBinaria()
                                .substring(
                                    direccionIP.nBitsMascaraInicial +
                                        (direccionIP.nBitsMascaraInicial / 8)
                                            .floor(),
                                    ((32 - direccionIP.nBitsMascaraFinal) +
                                            (32 -
                                                    direccionIP
                                                        .nBitsMascaraFinal) /
                                                8)
                                        .floor()),
                            style:
                                GoogleFonts.sourceCodePro(color: Colors.red)),
                        TextSpan(
                            text: direccionIP
                                .mascaraPunteadaBinaria()
                                .substring(((32 -
                                            direccionIP.nBitsMascaraFinal) +
                                        (32 - direccionIP.nBitsMascaraFinal) /
                                            8)
                                    .floor()),
                            style:
                                GoogleFonts.sourceCodePro(color: Colors.green)),
                      ],
                    ),
                  ),
                  Text(direccionIP.mascaraPunteadaDecimal()),
                  Text("/${32 - direccionIP.nBitsMascaraFinal}"),
                ],
              ),
            if (!direccionIP.error)
              Expanded(
                child: Card(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                    ),
                    itemBuilder: (buildContext, index) {
                      if (index != 0) {
                        direccionIP.calcularRed(index);
                      }
                      return ListTile(
                        leading: Text(
                          "$index",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: Text(direccionIP.toString()),
                      );
                    },
                    itemCount: direccionIP.nRedes,
                    scrollDirection: Axis.vertical,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  entrada(String titulo,
      {String hint = "",
      TextEditingController? controller,
      Function(String)? onSubmitted}) {
    return ListTile(
      leading: SizedBox(width: 90, child: Text(titulo)),
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(hintText: hint),
        onFieldSubmitted: onSubmitted,
      ),
    );
  }

  void calcularDesdeEntradaTexto(String s) {
    if (dirIP.text.isNotEmpty &&
        mascaraSubRed.text.isNotEmpty &&
        tamRed.text.isNotEmpty) {
      calcular();
    }
  }

  void calcular() {
    strIP = dirIP.text;
    strMascara = mascaraSubRed.text;
    strTamRed = tamRed.text;

    primeraCorrida = false;
    setState(() {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }
}
