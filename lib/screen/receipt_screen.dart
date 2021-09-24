import 'package:flutter/material.dart';
import 'package:testproject/bussiness/pdf_api.dart';
import 'package:testproject/bussiness/pdf_invoice.dart';
import 'package:testproject/bussiness/weight_database.dart';
import 'package:testproject/model/Weight.dart';

class ReceiptScreen extends StatefulWidget {
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  List<String> columns = ['PRODUCT ID', 'PRODUCT WEIGHT'];
  late List<Weight> weights;
  bool isLoading = false;
  num totalWeight = 0;
  @override
  void initState() {
    super.initState();
    obtainWeight();
  }

  void obtainWeight() async {
    setState(() {
      isLoading = true;
    });
    weights = await WeightDatabase.instance.readallWeights();
    if (weights.isNotEmpty) {
      this.totalWeight = await obtaintotalWeight();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<num> obtaintotalWeight() async {
    num total = (await WeightDatabase.instance.calculateTotal())[0]['Total'];
    return total;
  }

  Widget margin() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
    );
  }

  /*  Widget createReceipt() {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: weights.length,
        itemBuilder: (context, index) {
          final Weight weight = weights[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('${weight.id}', style: TextStyle(fontSize: 17.5)),
              SizedBox(
                width: 100,
              ),
              Text(
                '${weight.value}',
                style: TextStyle(fontSize: 17.5),
              ),
            ],
          );
        });
  } */
  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Center(
              child: Text(
                column,
                textAlign: TextAlign.center,
              ),
            ),
          ))
      .toList();
  getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(Align(
          alignment: Alignment.center,
          child: Text(
            '$data',
          ))))
      .toList();
  List<DataRow> getRows() => weights.map((Weight weight) {
        final cells = [weight.id, weight.value];
        return DataRow(cells: getCells(cells));
      }).toList();

  Widget createReceipt() {
    return SingleChildScrollView(
      child: DataTable(
        columns: getColumns(columns),
        rows: getRows(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('RECEIPT SCREEN'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : weights.isEmpty
              ? Center(
                  child: Text(
                    'No Weights',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      margin(),
                      Container(
                        width: double.maxFinite,
                        height: 200,
                        child: createReceipt(),
                      ),
                      margin(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('TOTAL WEIGHT:'),
                            Text(
                              '$totalWeight',
                              style: TextStyle(fontSize: 17.5),
                            ),
                          ],
                        ),
                      ),
                      margin(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                        child: FloatingActionButton(
                          onPressed: () async {
                            final pdfFile = await PdfInvoice.generatePdf(
                                weights, totalWeight);
                            PdfApi.openFile(pdfFile);
                          },
                          child: Image.asset(
                            'assets/pdf.png',
                            width: 40,
                            height: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
/*       */
    );
  }
}
