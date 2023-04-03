import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:image/image.dart' as img;
import 'package:printer/boton.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ticket Printer Demo',
      home: TicketPrintingPage(),
      //home: BotN(),
    );
  }
}

class TicketPrintingPage extends StatefulWidget {
  @override
  _TicketPrintingPageState createState() => _TicketPrintingPageState();
}

class _TicketPrintingPageState extends State<TicketPrintingPage> {
  final flutterUsbPrinter = FlutterUsbPrinter();
  late List<Map<String, dynamic>> devices = [];
  late bool connected = false;
  List<int> _ticketBytes = [];
  // int vendorId = 0;
  // int productId = 0;

  void _generateTicket() async {
    final bytes = await rootBundle.load('assets/logo.jpg');
    final buffer = bytes.buffer;
    final image = img.decodeImage(Uint8List.view(buffer));
    // Convierte la imagen a escala de grises y la redimensiona a 384 píxeles de ancho (tamaño de una impresora térmica estándar)
    final grayscaleImage = img.grayscale(image!);
    final resizedImage = img.copyResize(grayscaleImage, width: 384);
    // Convierte la imagen a un arreglo de bytes en formato BMP
    final bmpBytes = img.encodeBmp(resizedImage);
    await _print(bmpBytes);
    // Aquí generamos el contenido del ticket como una cadena de texto
    String ticketContent = "ULTRABICY MX METROPOLITANO\n\n"
        "Orden: UW3ZKx \n"
        "Fecha: 21/03/2023\n"
        ""
        "Detalles de compra:\n"
        "- Artículo 1: \$10\n"
        "- Artículo 2: \$20\n"
        "- Total: \$30\n\n"
        "Gracias por su compra.";

    // Convertimos la cadena de texto en bytes usando la codificación UTF-8
    _ticketBytes = utf8.encode(ticketContent);
  }

  _print(Uint8List logo) async {
    //await _connect(0x0416, 0x5011);

    try {
      var data = Uint8List.fromList(
        utf8.encode("Fecha: 21/03/2023\n"
            "Horario: 12:03:02 a 13:03:02\n"
            "Detalles de orden:\n\n"
            "- M0343 Bicicleta doble: \$260\n"
            "- M04553 Bicicleta sensilla: \$200\n\n"
            "- Total: \$460\n\n"),
      );
      var leyenda = Uint8List.fromList(utf8.encode(
          "\x1B\x211 AL PAGAR Y USAR LOS VEHICULOS ARRENDADOS POR ULTRA BICY MX, ACEPTO LOS TERMINOS DEL CONTRATO Y DECLARO BAJO PROTESTA DE DECIR VERDAD HABER LEIDO Y ACEPTADO LOS TERMINOS Y CONDICIONES QUE RIGEN EL CONTRATO QUE OBRA VISIBLE PUBLICAMENTE  EN EL ESTABLECIMIENTO Y QUE ME FUE EXPLICADO POR PERSONAL DEL ESTABLECIMIENTO Y SOY CONOCEDOR Y ME OBLIGO A RESPETAR LAS MEDIDAS DE SEGURIDAD Y A GUARDAR EL DEBIDO COMPORTAMIENTO DENTRO DE LAS INSTALACIONES DEL PARQUE ECOLOGICO EXPLORA / PARQUE METROPOLITANO, AL USAR EL VEHICULO ACEPTO EL CONTRATO Y LIBERO DE TODA RESPONSABILIDAD PENAL O CIVIL Y/O DE CUALQUIER ACCIDENTE O LESION QUE PUDIERA SUFRIR EN MI PERSONA O TERCEROS ADULTOS O MENORES A MI CARGO CON  MOTIVO DE NEGLIGENCIA, DESCUIDO O IMPRUDENCIA EN QUE INCURRA AL HACER USO DE LOS VEHICULOS MECANICOS Y ELECTRICOS."));
      var leyenda2 =
          'AL PAGAR Y USAR LOS VEHICULOS ARRENDADOS POR ULTRA BICY MX, ACEPTO LOS TERMINOS DEL CONTRATO Y DECLARO BAJO PROTESTA DE DECIR VERDAD HABER LEIDO Y ACEPTADO LOS TERMINOS Y CONDICIONES QUE RIGEN EL CONTRATO QUE OBRA VISIBLE PUBLICAMENTE  EN EL ESTABLECIMIENTO Y QUE ME FUE EXPLICADO POR PERSONAL DEL ESTABLECIMIENTO Y SOY CONOCEDOR Y ME OBLIGO A RESPETAR LAS MEDIDAS DE SEGURIDAD Y A GUARDAR EL DEBIDO COMPORTAMIENTO DENTRO DE LAS INSTALACIONES DEL PARQUE ECOLOGICO EXPLORA / PARQUE METROPOLITANO, AL USAR EL VEHICULO ACEPTO EL CONTRATO Y LIBERO DE TODA RESPONSABILIDAD PENAL O CIVIL Y/O DE CUALQUIER ACCIDENTE O LESION QUE PUDIERA SUFRIR EN MI PERSONA O TERCEROS ADULTOS O MENORES A MI CARGO CON  MOTIVO DE NEGLIGENCIA, DESCUIDO O IMPRUDENCIA EN QUE INCURRA AL HACER USO DE LOS VEHICULOS MECANICOS Y ELECTRICOS.';
      await flutterUsbPrinter.write(logo);
      await flutterUsbPrinter
          .printText("\x1B\x21\x21ULTRABICY MX METROPOLITANO\n");
      await flutterUsbPrinter.printText("\x1B\x21\x21Orden: UW3ZKx \n\n");
      await flutterUsbPrinter.write(data);
      await flutterUsbPrinter.printText('\x1B\x21\x01$leyenda2\n');
      // await FlutterUsbPrinter.printRawData("text");
      // await FlutterUsbPrinter.printText("Testing ESC POS printer...");
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
  }

  Future<void> _getDevicelist() async {
    List<Map<String, dynamic>> results = [];
    results = await FlutterUsbPrinter.getUSBDeviceList();
    print(" length: ${results.length}");
    setState(() {
      devices = results;
    });
    // vendorId = devices.first['vendorId'];
    // productId = devices.first['productId'];
  }

  _connect(int vendorId, int productId) async {
    late bool returned;
    try {
      returned = (await flutterUsbPrinter.connect(vendorId, productId))!;
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
    if (returned) {
      setState(() {
        connected = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Printer Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: Text('Revisar dispositivos conectados'),
              onPressed: () async => await _getDevicelist(),
            ),
            MaterialButton(
              child: Text('Generar ticket'),
              onPressed: () async => _generateTicket(),
            ),
            MaterialButton(
              child: Text('Conectar'),
              onPressed: () async => await _connect(1155, 22304),
            ),
            // SizedBox(height: 16),
            // MaterialButton(
            //   child: Text('Imprimir ticket'),
            //   onPressed: _ticketBytes.isEmpty ? null : () => _print(),
            // ),
            Text(devices.toList().toString()),
            Text('Conectado = $connected'),
            //  MaterialButton(
            //   child: Text('Imprimir'),
            //   onPressed: () async => await _print(),
            // ),
          ],
        ),
      ),
    );
  }
}
