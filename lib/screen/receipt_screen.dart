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
  late List<Weight> weights;
  bool isLoading = false;
  num totalWeight = 0;
  @override
  void initState() {
    super.initState();
    obtainWeight();
    obtaintotalWeight();
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

  Widget createReceipt() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('RECIPT SCREEN'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : weights.isEmpty
              ? Center(
                  child: Text(
                    'No Notes',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('PRODUCT ID'),
                          SizedBox(
                            width: 100,
                          ),
                          Text('PRODUCT WEIGHT'),
                        ],
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 200,
                        child: createReceipt(),
                      ),
                      margin(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('TOTAL WEIGHT:'),
                            SizedBox(
                              width: 50,
                            ),
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
