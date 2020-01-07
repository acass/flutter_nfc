import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

     SystemChrome.setPreferredOrientations ([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: NFCReader(),
    );
  }
}

class NFCReader extends StatefulWidget {
    @override
    _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State {
    bool _supportsNFC = false;
    bool _reading = false;
    StreamSubscription<NDEFMessage> _stream;

    @override
    void initState() {
        super.initState();
        // Check if the device supports NFC reading
        NFC.isNDEFSupported
            .then((bool isSupported) {
                setState(() {
                    _supportsNFC = isSupported;
                });
            });
    }

    @override
    Widget build(BuildContext context) {
        if (!_supportsNFC) {
            return RaisedButton(
                child: const Text("You device does not support NFC", style: TextStyle(color: Colors.white),),
                onPressed: null,
            );
        }

        return RaisedButton(
            child: Text(_reading ? "Stop reading" : "Start reading"),
            onPressed: () {
                if (_reading) {
                    _stream?.cancel();
                    setState(() {
                        _reading = false;
                    });
                } else {
                    setState(() {
                        _reading = true;
                        // Start reading using NFC.readNDEF()
                        _stream = NFC.readNDEF(
                            once: true,
                            throwOnUserCancel: false,
                        ).listen((NDEFMessage message) {
                            print('Read NDEF message: ${message.payload}');
                        }, onError: (e) {
                            // Check error handling guide below
                        });
                    });
                }
            }
        );
    }
}