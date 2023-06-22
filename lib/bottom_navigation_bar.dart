import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final Function(int) onTap;

  const BottomNavigationBarWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_back),
          label: 'Backbutton',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volume_up),
          label: 'Volume',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }
}