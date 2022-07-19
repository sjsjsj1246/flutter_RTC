import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100]!,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(child: _Logo()),
                Expanded(child: _Image()),
                Expanded(child: _EntryButton())
              ],
            ),
          ),
        ));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.blue[300]!,
                    blurRadius: 12.0,
                    spreadRadius: 2.0)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.videocam, color: Colors.white, size: 40.0),
              SizedBox(width: 12.0),
              Text('LIVE',
                  style: TextStyle(
                      color: Colors.white, fontSize: 30.0, letterSpacing: 4.0))
            ]),
          )),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'asset/img/home_img.png',
        width: 200.0,
        height: 200.0,
      ),
    );
  }
}

class _EntryButton extends StatelessWidget {
  const _EntryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('입장하기'),
        )
      ],
    );
  }
}
