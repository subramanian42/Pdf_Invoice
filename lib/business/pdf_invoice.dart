import 'dart:io';

//import 'package:pdf/pdf.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:testproject/business/pdf_api.dart';

import 'package:testproject/model/Weight.dart';

class PdfInvoice {
  static Future<File> generatePdf(List<Weight> weights, num totalWeight) async {
    final pdf = Document();
    pdf.addPage(MultiPage(
        build: (context) => [
              buildTitle(),
              buildInvoice(weights),
              Divider(),
              buildTotal(weights),
            ]));
    return PdfApi.saveDocument(name: 'Weights_Receipt.pdf', pdf: pdf);
  }

  static Widget buildTitle() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'INVOICE',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
    ]);
  }

  static Widget buildInvoice(List<Weight> weights) {
    final headers = [
      'Product Id',
      'Product Weight',
    ];
    final List<List<String>> data = weights.map((weight) {
      return [
        '${weight.id}',
        '${weight.value}',
      ];
    }).toList();
    return Table.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 30,
        cellAlignments: {
          0: Alignment.center,
          1: Alignment.center,
        });
  }

  static Widget buildTotal(List<Weight> weights) {
    final totalWeight = weights
        .map((weight) => weight.value)
        .reduce((value1, value2) => value1 + value2);

    return Container(
      alignment: Alignment.center,
      child: Row(children: [
        Spacer(flex: 5),
        Expanded(
            flex: 5,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Row(
                  children: [
                    Text('Total Weight',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 0.8 * PdfPageFormat.cm),
                    Text('$totalWeight',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 2 * PdfPageFormat.mm),
              Container(height: 1, color: PdfColors.grey400),
              SizedBox(height: 0.5 * PdfPageFormat.mm),
              Container(height: 1, color: PdfColors.grey400),
            ]))
      ]),
    );
  }
}
