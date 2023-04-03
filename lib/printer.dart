// // import 'package:flutter/material.dart';
// // import 'package:flutter_usb_printer/flutter_usb_printer.dart';

// // class Printer extends StatefulWidget {
// //   const Printer({ Key? key }) : super(key: key);

// //   @override
// //   _PrinterState createState() => _PrinterState();
// // }

// // class _PrinterState extends State<Printer> {
// //   _getDevicelist() async {
// //     List<Map<String, dynamic>> results = [];
// //     results = await FlutterUsbPrinter.getUSBDeviceList();

// //     print(" length: ${results.length}");
// //     setState(() {
// //       devices = results;
// //     });
// // }

// // _connect(int vendorId, int productId) async {
// //     bool returned;
// //     try {
// //       returned = await flutterUsbPrinter.connect(vendorId, productId);
// //     } on PlatformException {
// //       //response = 'Failed to get platform version.';
// //     }
// //     if (returned) {
// //       setState(() {
// //         connected = true;
// //       });
// //     }
// // }

// // _print() async {
// //     try {
// //       var data = Uint8List.fromList(
// //           utf8.encode(" Hello world Testing ESC POS printer..."));
// //       await flutterUsbPrinter.write(data);
// //       // await FlutterUsbPrinter.printRawData("text");
// //       // await FlutterUsbPrinter.printText("Testing ESC POS printer...");
// //     } on PlatformException {
// //       //response = 'Failed to get platform version.';
// //     }
// // }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
      
// //     );
// //   }
// // }

// // class UsbDevice {
// // }

// import 'package:flutter_usb_printer/flutter_usb_printer.dart';

// void printText(String text, int fontSize) async {
//   try {
//     // Obtener las impresoras USB conectadas
//     List<USBPrinter> printers = await FlutterUsbPrinter.getPrinters();

//     // Comprobar si hay impresoras conectadas
//     if (printers.isEmpty) {
//       print('No se encontró ninguna impresora conectada.');
//       return;
//     }

//     // Seleccionar la primera impresora USB encontrada
//     USBPrinter printer = printers.first;

//     // Conectar a la impresora
//     await printer.connect();

//     // Enviar la secuencia de comandos de la impresora para cambiar el tamaño del texto
//     String fontSizeCommand = '\x1B\x21${fontSize.toString()}';

//     // Imprimir el texto con el tamaño de letra especificado
//     await printer.printText(fontSizeCommand + text + '\n');

//     // Desconectar la impresora
//     await printer.disconnect();
//   } catch (e) {
//     print('Error al imprimir: $e');
//   }
// }

// // Ejemplo de uso
// void main() {
//   printText('Este texto se imprimirá con un tamaño de letra más grande.', 2);
// }
