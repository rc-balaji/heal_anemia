import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HPMeterPage extends StatefulWidget {

  final String gender;

  HPMeterPage({required this.gender});

  @override
  _HPMeterPageState createState() => _HPMeterPageState();
}

class _HPMeterPageState extends State<HPMeterPage> {
  final client = MqttServerClient.withPort('broker.hivemq.com', 'flutter_client_${DateTime.now().millisecondsSinceEpoch}', 1883);
  final String topic = 'demomqtt';
  List<double> hpValues = [];
  bool running = false;


  @override
  void initState() {
    super.initState();
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
  }

  void connect() async {
    try {
      await client.connect();
    } catch (e) {
      debugPrint('Exception: $e');
      client.disconnect();
    }
  }

  void disconnect() {
    client.disconnect();
  }

  void start() {
    setState(() {
      running = true;
      hpValues.clear();
    });
    connect();
  }

  void stop() {
    setState(() {
      running = false;
    });
    disconnect();
  }

  void onConnected() {
    debugPrint('Connected');
    client.subscribe(topic, MqttQos.atLeastOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final hpValue = jsonDecode(pt)['msg']['HP Value'];
      setState(() {
        hpValues.add(hpValue);
      });
    });
  }

  void onSubscribed(String topic) {
    debugPrint('Subscribed to $topic');
  }

  void onDisconnected() {
    debugPrint('Disconnected');
  }

  String getAnemiaGrade(double hpValue) {


    if (hpValue >= 14 && widget.gender=='men') return 'Normal';
    if (hpValue >= 12 && widget.gender=='women' ) return 'Normal';
    if (hpValue >= 10) return 'Mild';
    if (hpValue >= 8) return 'Moderate';
    if (hpValue >= 6.5) return 'Severe';
    return 'Life-threatening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HP Meter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hpValues.isNotEmpty)
              Text(
                'Latest HP Value: ${hpValues.last}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            if (hpValues.isNotEmpty)
              Text(
                'Anemia Grade: ${getAnemiaGrade(hpValues.last)}',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: running ? null : start,
              child: Text('Start'),
            ),
            ElevatedButton(
              onPressed: running ? stop : null,
              child: Text('Stop'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: hpValues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('HP Value: ${hpValues[index]}'),
                    subtitle: Text('Anemia Grade: ${getAnemiaGrade(hpValues[index])}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
