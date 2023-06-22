import 'dart:convert';
import 'package:multipageluna/utilities/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:csv/csv.dart';
import 'bottom_navigation_bar.dart';

class DynamicTemplate extends StatefulWidget {
  const DynamicTemplate({Key? key}) : super(key: key);

  @override
  State<DynamicTemplate> createState() => _DynamicTemplateState();
}

class _DynamicTemplateState extends State<DynamicTemplate> {
  List<PlaceholderData> placeholderDataList = [];
  Map<String, String> _translations = {};
  bool _showTranslatedText = true;
  late PageController pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    pageController = PageController(initialPage: 1);
  }

  void _onBottomNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:

        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
      showDialog(
        context: context,
        builder: _buildLanguageOptionsDialog,
      );
      break;
    }
  }

Future<Map<String, dynamic>> parseJsonFromAssets(String fileName) async {
    try {
      final file = await rootBundle.loadString(fileName);
      return json.decode(file);
    } on Exception catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

Widget _buildLanguageOptionsDialog(BuildContext context) {
  return Dialog(
    child: Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select a language'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('English'),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Spanish'),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('French'),
          ),
        ],
      ),
    ),
  );
}

Future<Map<String, String>> _readTranslations() async {
  print("reached translation");
  String csvString = await rootBundle.loadString('assets/translations.csv');
  List<List<dynamic>> csvTable = CsvToListConverter(fieldDelimiter: ',').convert(csvString);
  Map<String, String> translations = {};
  for (List<dynamic> row in csvTable) {
    if (row.length >= 5 && row[0] != null && row[3] != null && row[4] != null) {
      // String key = '${row[0]}_${row[2]}';
      String key = '${row[1]}';
      translations[key] = row[3];
    }
  }
  return translations;
}

  void _loadData() async {
  try {
    Map<String, dynamic>? data = await _readDataFromJsonFile();
    if (data == null) {
      throw SomethingWentWrong("Failed to load data from JSON file");
    }
    // print("reached");
    int slideCount = data.length;
    placeholderDataList = [];
    _translations = await _readTranslations();
    // print(_translations);
    for (int i = 1; i <= slideCount; i++) {
      Map<String, dynamic> slideData = data['slide$i'];

      slideData.forEach((key, value) {
        placeholderDataList.add(PlaceholderData.fromJson(
          {
            'title': value['title'],
            'type': value['type'],
            // 'text': (_showTranslatedText ? _translations[value['text_translated']] : _translations[value['text_original']]) ?? value['text'],

            'text': _showTranslatedText ? _translations[value['text']] : value['text'],
            'url' : value['url'],
            'textId': value['text_id'],
            'fontName' : value['font_name'],
            'fontSize' : value['font_size'],
            'width': value['width'],
            'height': value['height'],
            'left': value['left'],
            'top': value['top'],
            'right': value['right'],
            'bottom': value['bottom']
          },
          pageNumber: i,
        ));
      });
    }
    print(placeholderDataList[0].text);
    setState(() {});
  } on Exception catch (e) {
    print(e);
    throw SomethingWentWrong(e.toString());
    }
  }

  Future _readDataFromJsonFile() async {
    try {
      Map<String, dynamic> data =
          await parseJsonFromAssets('assets/placeholder.json');
      return data;
    } on Exception catch (e) {
      SomethingWentWrong(e.toString());
    }
  }


  @override
Widget build(BuildContext context) {

  double navBarHeight = kBottomNavigationBarHeight;
  double relativeHeight = (MediaQuery.of(context).size.height - navBarHeight) / 100;
  double relativeWidth = MediaQuery.of(context).size.width / 100;
  
  final FlutterTts flutterTts = FlutterTts();

  
  
  
  return Scaffold(
    
    body: (placeholderDataList.isEmpty)
        ? const Center(child: Text("Assets not found"))
        : PageView.builder(
            onPageChanged:(index) {
              // setState(() {});
              flutterTts.stop();},
    
            itemCount: placeholderDataList.last.pageNumber + 1,
            itemBuilder: (BuildContext context, int pageIndex) {
              return Stack(
                children: placeholderDataList
                    .where((element) => element.pageNumber == pageIndex)
                    .map(
                      (e) => Positioned(
                        width: (e.width * relativeWidth),
                        height: (e.height * relativeHeight),
                        left: (e.left * relativeWidth),
                        top: (e.top * relativeHeight),
                        child: (e.type == "text")
                            ? (e.url != '')
                                ? InkWell(
                                    onTap: () {
                                      int page= int.parse(e.url[5]);
                                      if (page != null) {
                                          pageController.jumpToPage(page);
                                        }
                                    },
                                    child: Text(
                                      e.text,
                                      style: TextStyle(
                                          fontSize: e.fontSize == 0.0
                                              ? 14
                                              : e.fontSize),
                                    ),
                                  )
                                : InkWell(
                                  onTap: () async {
                                    await flutterTts.setLanguage("en-US");
                                    await flutterTts.speak(e.text);
                                  },
                                  child: Text(
                                      e.text,
                                      style: TextStyle(
                                          fontSize:
                                              e.fontSize == 0.0 ? 14 : e.fontSize),
                                    ),
                                )
                            : Container(
                                child: Image.asset(
                                  'assets/${e.url.split('/').last}',
                                ),
                              ),
                      ),
                    )
                    .toList(),
              );
            },
            controller: pageController,
          ),
        floatingActionButton: FloatingActionButton(
         onPressed: () {
          setState(() {
            _showTranslatedText = !_showTranslatedText;
            placeholderDataList.clear();
            _loadData();
          }); 
        },
        child: Icon(Icons.language),
      ),
    bottomNavigationBar: BottomNavigationBarWidget(onTap: _onBottomNavBarItemTapped),
  );
}
}

class PlaceholderData {
  final String title;
  final String type;
  final String text;
  final String url;
  final String textId;
  final String fontName;
  final double fontSize;
  final double width;
  final double height;
  final double left;
  final double top;
  final double right;
  final double bottom;
  
  final int pageNumber;

  PlaceholderData({
    required this.title,
    required this.type,
    required this.text,
    required this.url,
    required this.textId,
    required this.fontName,
    required this.fontSize,
    required this.width,
    required this.height,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.pageNumber,
  });

  factory PlaceholderData.fromJson(Map<String, dynamic> json, {required int pageNumber}) {
    return PlaceholderData(
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      text: json['text'] ?? '',
      url: json['url'] ?? '',
      textId: json['text_id'] ?? '',
      fontName: json['font_name'] ?? '',
      fontSize: json['font_size']?.toDouble() ?? 0.0,
      width: json['width']?.toDouble() ?? 0.0,
      height: json['height']?.toDouble() ?? 0.0,
      left: json['left']?.toDouble() ?? 0.0,
      top: json['top']?.toDouble() ?? 0.0,
      right: json['right']?.toDouble() ?? 0.0,
      bottom: json['bottom']?.toDouble() ?? 0.0,
      pageNumber: pageNumber,
    );
}
}


/*
Copyright <2023> <Kishan Nagendra & others>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE


*/