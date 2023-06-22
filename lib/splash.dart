import 'package:multipageluna/utilities/exceptions.dart';
import 'package:flutter/material.dart';
import 'home.dart';



class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _showHome();
  }


  _showHome() async{
    try {
      await Future.delayed(const Duration(milliseconds: 1500), () {});
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context)=> const MyHomePage(
            title: 'Luna mHealth',
            )));
    } on Exception catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      // ignore: prefer_const_constructors
      body: Center(
        child: const Text('Luna mHealth',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
      )
    );
  }
}

/*
Copyright <2023> <Kishan Nagendra & others>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE


*/