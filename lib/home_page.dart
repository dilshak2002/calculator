import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String displayValue = "0";
  String displayValue_1 = "";
  bool isReplace = false;
  num result = 0;
  num firstValue = 0;
  num secondValue = 0;
  String operatorValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 25,
              ),
              IconButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  int count = prefs.getInt("count") ?? 0;
                  List<ListTile> calHistory = [];
                  for (int i = 1; i < count; i++) {
                    calHistory.add(ListTile(
                      title: Text("${prefs.getString("val_$i")}"),
                    ));
                  }
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(10),
                      child: ListView(children: calHistory),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.history,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              Text(
                displayValue_1,
                style: const TextStyle(
                    color: Color.fromARGB(255, 241, 244, 247), fontSize: 40),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                displayValue,
                style: const TextStyle(color: Colors.white, fontSize: 60),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      calculatorButton(
                        buttonName: "C",
                      ),
                      calculatorButton(buttonName: "7"),
                      calculatorButton(buttonName: "4"),
                      calculatorButton(buttonName: "1"),
                      calculatorButton(buttonName: "%"),
                    ],
                  ),
                  Column(
                    children: [
                      calculatorButton(icon: Icons.backspace),
                      calculatorButton(buttonName: "8"),
                      calculatorButton(buttonName: "5"),
                      calculatorButton(buttonName: "2"),
                      calculatorButton(buttonName: "0"),
                    ],
                  ),
                  Column(
                    children: [
                      calculatorButton(buttonName: "/", isOperatorButton: true),
                      calculatorButton(buttonName: "9"),
                      calculatorButton(buttonName: "6"),
                      calculatorButton(buttonName: "3"),
                      calculatorButton(buttonName: "."),
                    ],
                  ),
                  Column(
                    children: [
                      calculatorButton(buttonName: "*", isOperatorButton: true),
                      calculatorButton(buttonName: "-", isOperatorButton: true),
                      calculatorButton(buttonName: "+", isOperatorButton: true),
                      calculatorButton(
                          buttonName: "=",
                          isEquelButton: true,
                          isOperatorButton: true),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void calculationProcess({required String buttonName}) {
    setState(() {
      // press "C" button
      if (buttonName == "C") {
        displayValue = "0";
        displayValue_1 = "";
        isReplace = false;
      }

      //press riverse button
      else if (buttonName == "X") {
        displayValue = displayValue.substring(0, displayValue.length - 1);

        if (displayValue.isEmpty) {
          displayValue = "0";
        }
      }

      // press "=" button
      else if (buttonName == "=") {
        if (displayValue_1.endsWith("+") ||
            displayValue_1.endsWith("-") ||
            displayValue_1.endsWith("*") ||
            displayValue_1.endsWith("/") ||
            displayValue_1.endsWith("%")) {
          firstValue =
              num.parse(displayValue_1.substring(0, displayValue_1.length - 1));

          secondValue = num.parse(displayValue);

          operatorValue = displayValue_1[displayValue_1.length - 1];

          if (operatorValue == "+") {
            displayValue_1 = "$firstValue $operatorValue $secondValue =";

            result = firstValue + secondValue;

            displayValue = result.toString();
          } else if (operatorValue == "-") {
            displayValue_1 = "$firstValue $operatorValue $secondValue =";

            result = firstValue - secondValue;

            displayValue = result.toString();
          } else if (operatorValue == "*") {
            displayValue_1 = "$firstValue $operatorValue $secondValue =";

            result = firstValue * secondValue;

            displayValue = result.toString();
          } else if (operatorValue == "/") {
            displayValue_1 = "$firstValue $operatorValue $secondValue =";

            result = firstValue / secondValue;

            displayValue = result.toString();
          }
          else if (operatorValue == "%") {
            displayValue_1 = "$firstValue $operatorValue $secondValue =";

            result = firstValue % secondValue;

            displayValue = result.toString();
          }

          saveData();
        }
      }

      //press operators button
      else if (buttonName == "+" ||
          buttonName == "-" ||
          buttonName == "*" ||
          buttonName == "/" ||
          buttonName == "%") {
        if (displayValue != "0" && displayValue_1.isEmpty) {
          displayValue_1 = displayValue + buttonName;
        } else if (displayValue_1.isNotEmpty) {
          firstValue =
              num.parse(displayValue_1.substring(0, displayValue_1.length - 1));

          secondValue = num.parse(displayValue);

          operatorValue = displayValue_1[displayValue_1.length - 1];

          if (displayValue_1.endsWith("+") ||
              displayValue_1.endsWith("-") ||
              displayValue_1.endsWith("*") ||
              displayValue_1.endsWith("/") ||
              displayValue_1.endsWith("%")) {
            if (operatorValue == "+") {
              result = firstValue + secondValue;

              displayValue = result.toString();

              displayValue_1 = "$result $buttonName";
            } else if (operatorValue == "-") {
              result = firstValue - secondValue;

              displayValue = result.toString();

              displayValue_1 = "$result $buttonName";
            } else if (operatorValue == "*") {
              result = firstValue * secondValue;

              displayValue = result.toString();

              displayValue_1 = "$result $buttonName";
            } else if (operatorValue == "/") {
              result = firstValue / secondValue;

              displayValue = result.toString();

              displayValue_1 = "$result $buttonName";
            } else if (operatorValue == "%") {
              result = firstValue % secondValue;

              displayValue = result.toString();

              displayValue_1 = "$result $buttonName";
            }

            isReplace = false;
          }
        }
      }

      //press numbers button
      else if (int.tryParse(buttonName) != null) {
        if (displayValue_1 != "") {
          if (displayValue_1.endsWith("+") ||
              displayValue_1.endsWith("-") ||
              displayValue_1.endsWith("*") ||
              displayValue_1.endsWith("/") ||
              displayValue_1.endsWith("%")) {
            if (isReplace) {
              displayValue = displayValue + buttonName;
            } else {
              displayValue = buttonName;
              isReplace = true;
            }
          } else if ((displayValue_1[displayValue_1.length - 1] == "=")) {
            displayValue = buttonName;
            displayValue_1 = "";
            isReplace = false;
          }
        } else {
          if (displayValue == "0") {
            displayValue = buttonName;
          } else {
            displayValue = displayValue + buttonName;
          }
        }
      }

      //press .
      else if(buttonName == "."){
        displayValue = displayValue + buttonName;
      }
    });
  }

  Future<void> saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int valueCount = 1;

    if (prefs.containsKey("count")) {
      valueCount = prefs.getInt("count")!;

      prefs.setInt("count", valueCount + 1);
    } else {
      prefs.setInt("count", 1);
    }

    prefs.setString("val_$valueCount", "$displayValue_1 $displayValue");
  }

  Padding calculatorButton(
      {String? buttonName, IconData? icon, bool isEquelButton = false, bool isOperatorButton = false}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          if (buttonName != null) {
          calculationProcess(buttonName: buttonName);
        } else if (icon == Icons.backspace) {
          calculationProcess(buttonName: "X"); // Keep the same logic for backspace
        }
        },
        child: Container(
          width: 65,
          height: isEquelButton == true ? 140 : 65,
          decoration: BoxDecoration(
              color: isOperatorButton == true
                  ? const Color.fromARGB(255, 248, 150, 59)
                  : const Color(0xff313538),
              borderRadius: BorderRadius.circular(50)),
          child: Center(
               child: icon != null
                ? Icon(icon, color: Colors.white, size: 20)
                : Text(
              buttonName ?? "",
            style: const TextStyle(color: Colors.white, fontSize: 20),
          )),
        ),
      ),
    );
  }
}
