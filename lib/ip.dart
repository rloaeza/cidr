import 'dart:math';

class IP {
  List ip = [];
  List mascara = [];
  List<int> red = [];

  bool error = false;
  String errorTXT = "";
  int nBitsMascaraInicial = 0;

  int nBitsMascaraFinal = 0;
  int nDispositivos = 0;

  int nRedes = 0;

  IP(String direccionIP, String mascaraSubRed, String tamRed) {
    error = false;
    direccionIP.split(".").forEach((element) {
      try {
        ip.add(int.parse(element));
      } on FormatException catch (_) {
        error = true;
        errorTXT = "Error en el formato numérico de la dirección IP";
        return;
      }
    });
    if (ip.length != 4) {
      error = true;
      errorTXT = "Error en la dirección ip";
      return;
    }
    mascaraSubRed.split(".").forEach((element) {
      try {
        mascara.add(int.parse(element));
      } on FormatException catch (_) {
        error = true;
        errorTXT = "Error en el formato numérico de la máscara de subred";
        return;
      }
    });
    int nDispositivos = 0;
    try {
      nDispositivos = int.parse(tamRed);
    } on Exception catch (_) {
      error = true;
      errorTXT = "Error en el formato numérico de la cantidad de dispositivos";
      return;
    }

    if (mascara.length != 4) {
      error = true;
      errorTXT = "Error en la máscara de subred";
      return;
    }

    for (int i = 0; i < ip.length; i++) {
      red.add(ip[i] & mascara[i]);
    }
    if (nDispositivos <= 0) {
      error = true;
      errorTXT = "Error en la cantidad de dispositivos";
      return;
    }
    while (pow(2, nBitsMascaraFinal) < nDispositivos) {
      nBitsMascaraFinal++;
    }

    for (int octeto in mascara) {
      while (octeto > 0) {
        octeto = (octeto << 1) - 256;
        nBitsMascaraInicial++;
      }
    }
    if ((nBitsMascaraInicial + nBitsMascaraFinal) > 32) {
      error = true;
      errorTXT = "Se ha superado la capacidad de dispositivos";
      return;
    }
    nRedes = pow(2, 32 - (nBitsMascaraFinal + nBitsMascaraInicial)).toInt();
  }
  sumar(int valor) {
    red[3] += valor;
    corregir();
  }

  corregir() {
    for (var i = 3; i > 1; i--) {
      red[i - 1] += (red[i] / 256).floor();
      red[i] = red[i] % 256;
    }
  }

  calcularRed(int n) {
    for (int indice = 0; indice < 4; indice++) {
      red[indice] = ip[indice] & mascara[indice];
    }

    sumar(n * pow(2, nBitsMascaraFinal).toInt());
  }

  @override
  String toString() {
    return "${red[0]}.${red[1]}.${red[2]}.${red[3]}";
  }

  String mascaraPunteadaBinaria() {
    String m = "";
    for (int i = 0; i < 32; i++) {
      m += i != 0 && i % 8 == 0 ? "." : "";
      m += i < (32 - nBitsMascaraFinal) ? "1" : "0";
    }
    return m;
  }

  String mascaraPunteadaDecimal() {
    String m = "";
    int octeto = 0;
    int aux = 0;

    for (int indice = 1; indice <= 32; indice++) {
      if (indice <= (32 - nBitsMascaraFinal)) {
        octeto = octeto + pow(2, (7 - aux)).toInt();
      }
      aux++;
      if ((indice % 8) == 0) {
        m += "$octeto.";
        octeto = 0;
        aux = 0;
      }
    }
    return m.substring(0, m.length - 1);
  }
}
