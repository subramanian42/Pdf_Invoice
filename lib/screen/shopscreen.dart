import 'package:flutter/material.dart';
import 'package:testproject/bussiness/weight_database.dart';
import 'package:testproject/model/Weight.dart';
import 'package:testproject/screen/receipt_screen.dart';

class ShopScreen extends StatefulWidget {
  ShopScreen({Key? key}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late FocusNode myFocusNode;
  int sum = 0;
  final TextEditingController weightcontroller = TextEditingController();
  bool _validate = false;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();

    super.dispose();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Color(0XFFFF8474);
    }
    return Color(0XFFC1CFC0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFE7E0C9),
        body: Padding(
          padding: EdgeInsets.only(left: 25, right: 25, top: 150),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                child: Image.asset("assets/weight.png"),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                focusNode: myFocusNode,
                decoration: InputDecoration(
                  labelText: 'Weight',
                  hintText: 'Enter Weight',
                  border: OutlineInputBorder(),
                  errorText:
                      _validate ? 'Weight value should not be null' : null,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: ElevatedButton(
                      child: Text('ADD'),
                      onPressed: () async {
                        setState(() {
                          weightcontroller.text.isEmpty
                              ? _validate = true
                              : _validate = false;
                        });
                        if (weightcontroller.text.isNotEmpty) {
                          Weight newWeight = Weight(
                            value: num.parse(weightcontroller.text),
                          );
                          await WeightDatabase.instance.create(newWeight);
                          setState(() {
                            weightcontroller.clear();
                            myFocusNode.requestFocus();
                          });
                        }
                      },
                    ),
                  ),
                ),
                controller: weightcontroller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith(getColor)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ReceiptScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'GENERATE RECIPT',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
