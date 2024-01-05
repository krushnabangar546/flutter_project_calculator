import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button_values.dart';

class calculator_Screen extends StatefulWidget {
  const calculator_Screen({super.key});

  @override
  State<calculator_Screen> createState() => _calculator_ScreenState();
}

class _calculator_ScreenState extends State<calculator_Screen> {
  String number1 = "";
  String operand = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    reverse: true,
                    child:
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "$number1$operand$number2".isEmpty
                            ?"0"
                            :"$number1$operand$number2",

                        style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.end,
                      ),
                    )
                ),
              ),

              Wrap(
                children:
                Btn.buttonValues.map((value) => SizedBox(
                    height: screenSize.width/5,
                    width: value==Btn.calculate?screenSize.width/2: screenSize.width/4,
                    child: buildButton(value))).toList(),
              )
            ],
          )),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: getButtonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(80),
            borderSide: BorderSide(color: Colors.white)
        ),

        child: InkWell(
          onTap: () =>  onButtonTap(value),
          child: Center(
              child: Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              )
          ),
        ),
      ),
    );
  }

  Color getButtonColor(value){
    return [Btn.del,Btn.clr].contains(value)?Colors.red:[
      Btn.per,
      Btn.multiply,
      Btn.divide,
      Btn.subtract,
      Btn.add,
    ].contains(value)?Colors.orangeAccent:[Btn.calculate,].contains(value)?Colors.green:Colors.lightBlueAccent;
  }
  // operation on buttons
  void onButtonTap(String value) {
    if(value == Btn.del){
      deleteFromEnd();
      return;
    }

    if(value == Btn.clr){
      clearAllOutput();
      return;
    }

    if(value == Btn.per){
      convertToPercent();
      return;
    }

    if(value == Btn.calculate){
      performCalculation();
      return;
    }

    appendValue(value);
  }

  void performCalculation(){
    if(number1.isEmpty)return;
    if(operand.isEmpty)return;
    if(number2.isEmpty)return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;

    switch(operand){
      case Btn.add:
        result = num1+num2;
        break;
      case Btn.subtract:
        result = num1-num2;
        break;
      case Btn.multiply:
        result = num1*num2;
        break;
      case Btn.divide:
        result = num1/num2;
        break;
      default:
    }

    setState(() {
      number1 = "$result";

      if(number1.endsWith(".0")){
        number1 = number1.substring(0, number1.length-2);
      }

      number2 = "";
      operand = "";
    });
  }

  // get percentages
  void convertToPercent(){
    if(number1.isNotEmpty&&operand.isNotEmpty&&number2.isNotEmpty){
      performCalculation();
    }

    if(operand.isNotEmpty){
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${number/100}";
      operand = "";
      number2 = "";
    });
  }

  // delete input from end
  void deleteFromEnd(){
    if(number2.isNotEmpty){
      number2 = number2.substring(0, number2.length-1);
    } else if(operand.isNotEmpty){
      operand = "";
    } else if (number1.isNotEmpty){
      number1 = number1.substring(0, number1.length-1);
    }
    setState(() {

    });

  }

  // clear or output
  void clearAllOutput(){
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  //append value on screen
  void appendValue(String value) {

    if(value!=Btn.dot && int.tryParse(value)== null){
      if(operand.isNotEmpty && number2.isNotEmpty){
        performCalculation();
      }
      operand = value;
    } else if(number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && number1.isEmpty || number1 == Btn.n0) {
        value = "0.";
      }
      number1 += value;
    } else if(number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && number2.isEmpty || number2 == Btn.n0) {
        value = "0.";
      }
      number2 += value;
    }
    setState(() {

    });

  }
}
