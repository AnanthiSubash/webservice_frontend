import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HelloWorldScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HelloWorldScreen extends StatefulWidget {
  @override
  _HelloWorldScreenState createState() => _HelloWorldScreenState();
}

class _HelloWorldScreenState extends State<HelloWorldScreen>
    with SingleTickerProviderStateMixin {
  String _message = 'Loading...';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchMessage();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 30).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<void> _fetchMessage() async {
    final response = await http.get(Uri.parse('http://164.90.155.97:3002/hello'));
    if (response.statusCode == 200) {
      setState(() {
        _message = json.decode(response.body)['message'];
      });
    } else {
      setState(() {
        _message = 'Failed to load message';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          _message,
          style: TextStyle(
            fontSize: 24,
            color: Colors.blue,
            shadows: [
              Shadow(
                blurRadius: _animation.value,
                color: Colors.blue,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
