import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MyWebViewPage extends StatefulWidget {
  const MyWebViewPage({super.key});

  @override
  _MyWebViewPageState createState() => _MyWebViewPageState();
}

class _MyWebViewPageState extends State<MyWebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    _loadMapWithCurrentLocation();
  }

  Future<void> _loadMapWithCurrentLocation() async {
    try {
      // Get the current location
      Position position = await _determinePosition();
      double latitude = position.latitude;
      double longitude = position.longitude;

      String regularIconBase64 =  'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0ndXRmLTgnPz48c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjIwMG1tIiBoZWlnaHQ9IjIwMG1tIiB2aWV3Qm94PSI1MCA1MCAxMDAgMTAwIiB2ZXJzaW9uPSIxLjEiPjxnIHRyYW5zZm9ybT0ibWF0cml4KDAuNzU4NTUzNTksMCwwLDAuNzU4NTUzNTksMjQuMTMyNzYzLDI0LjM1ODE5MSkiPjxwYXRoIHN0eWxlPSJmaWxsOiNmZmZmZmY7c3Ryb2tlOiMwMDAwMDA7c3Ryb2tlLXdpZHRoOjEzLjA2NTtzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2UtbWl0ZXJsaW1pdDoxO3N0cm9rZS1kYXNoYXJyYXk6bm9uZTtwYWludC1vcmRlcjpub3JtYWwiIGQ9Ik0gMTY0LjcwODgsMTI0Ljk5OTcxIEMgMTYwLjI5MTUsMTUwLjgwNjA0IDgyLjUyNTc4OSwxNzkuNTUyMDEgNjIuMzg1NDk4LDE2Mi44MjMzNSA0Mi4yNDUyMDYsMTQ2LjA5NDY5IDU2LjIzMzMyMyw2NC4zNzQ2MjYgODAuNzkwOTE0LDU1LjI5Njk1MyAxMDUuMzQ4NTEsNDYuMjE5MjggMTY5LjEyNjEsOTkuMTkzMzc0IDE2NC43MDg4LDEyNC45OTk3MSBaIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtOC4zODkyNDI5LC0xMS43NDQ5NCkiIC8+PC9nPjxnIHRyYW5zZm9ybT0ibWF0cml4KDAuNzU4NTUzNTksMCwwLDAuNzU4NTUzNTksMjQuMTMyNzYzLDI0LjM1ODE5MSkiPjxlbGxpcHNlIHN0eWxlPSJmaWxsOiMwMDAwMDA7c3Ryb2tlOiMwMDAwMDA7c3Ryb2tlLXdpZHRoOjE1LjgxOTc7c3Ryb2tlLWxpbmVjYXA6YnV0dDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLW1pdGVybGltaXQ6MTtzdHJva2UtZGFzaGFycmF5Om5vbmU7c3Ryb2tlLW9wYWNpdHk6MDtwYWludC1vcmRlcjpub3JtYWwiIHJ5PSIyNi4xNjczMjQiIHJ4PSIyNS43NDc4NjQiIGN5PSIxMjYuNTM3NzQiIGN4PSI5Mi41NjEzMDIiIC8+PC9nPjxnIHRyYW5zZm9ybT0ibWF0cml4KDAuNzU4NTUzNTksMCwwLDAuNzU4NTUzNTksMjQuMTMyNzYzLDI0LjM1ODE5MSkiPjxwYXRoIHN0eWxlPSJmaWxsOiMwMDAwMDA7c3Ryb2tlOiMwMDAwMDA7c3Ryb2tlLXdpZHRoOjEzLjA2NTtzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2UtbWl0ZXJsaW1pdDoxO3N0cm9rZS1kYXNoYXJyYXk6bm9uZTtzdHJva2Utb3BhY2l0eTowO3BhaW50LW9yZGVyOm5vcm1hbCIgZD0ibSA3NS4yMjM1NDcsOTIuNDIxNDk0IGEgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtNS45MzM0OTIsNy44MDk4NzYgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtOC4yOTg3MzIsLTQuNjk2NjYzIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgMi42MjU0MDgsLTkuNjgyMDgyIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgOS4zNDUyODYsMC44MzcxMzggbCAtNS4xNDg5NjgsNS43MzE3MzEgeiIgLz48cGF0aCBzdHlsZT0iZmlsbDojMDAwMDAwO3N0cm9rZTojMDAwMDAwO3N0cm9rZS13aWR0aDoxMy4wNjU7c3Ryb2tlLWxpbmVjYXA6YnV0dDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLW1pdGVybGltaXQ6MTtzdHJva2UtZGFzaGFycmF5Om5vbmU7c3Ryb2tlLW9wYWNpdHk6MDtwYWludC1vcmRlcjpub3JtYWwiIGQ9Im0gMTAyLjYyODQsODIuNjM0MDQxIGEgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtNS45MzM0OTEsNy44MDk4NzQgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtOC4yOTg3MzIsLTQuNjk2NjYxIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgMi42MjU0MDgsLTkuNjgyMDgyIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgOS4zNDUyODUsMC44MzcxMzkgbCAtNS4xNDg5NjcsNS43MzE3MyB6IiAvPjwvZz48L3N2Zz4=';
      String grayIconBase64 =     'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0ndXRmLTgnPz48c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjIwMG1tIiBoZWlnaHQ9IjIwMG1tIiB2aWV3Qm94PSI1MCA1MCAxMDAgMTAwIiB2ZXJzaW9uPSIxLjEiPjxnIHRyYW5zZm9ybT0ibWF0cml4KDAuNzU4NTUzNTksMCwwLDAuNzU4NTUzNTksMjQuMTMyNzYzLDI0LjM1ODE5MSkiPjxwYXRoIHN0eWxlPSJmaWxsOiNmZmZmZmY7c3Ryb2tlOiM4ODg4ODg7c3Ryb2tlLXdpZHRoOjEzLjA2NTtzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2UtbWl0ZXJsaW1pdDoxO3N0cm9rZS1kYXNoYXJyYXk6bm9uZTtwYWludC1vcmRlcjpub3JtYWwiIGQ9Ik0gMTY0LjcwODgsMTI0Ljk5OTcxIEMgMTYwLjI5MTUsMTUwLjgwNjA0IDgyLjUyNTc4OSwxNzkuNTUyMDEgNjIuMzg1NDk4LDE2Mi44MjMzNSA0Mi4yNDUyMDYsMTQ2LjA5NDY5IDU2LjIzMzMyMyw2NC4zNzQ2MjYgODAuNzkwOTE0LDU1LjI5Njk1MyAxMDUuMzQ4NTEsNDYuMjE5MjggMTY5LjEyNjEsOTkuMTkzMzc0IDE2NC43MDg4LDEyNC45OTk3MSBaIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtOC4zODkyNDI5LC0xMS43NDQ5NCkiIC8+PC9nPjxnIHRyYW5zZm9ybT0ibWF0cml4KDAuNzU4NTUzNTksMCwwLDAuNzU4NTUzNTksMjQuMTMyNzYzLDI0LjM1ODE5MSkiPjxlbGxpcHNlIHN0eWxlPSJmaWxsOiM4ODg4ODg7c3Ryb2tlOiM4ODg4ODg7c3Ryb2tlLXdpZHRoOjE1LjgxOTc7c3Ryb2tlLWxpbmVjYXA6YnV0dDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLW1pdGVybGltaXQ6MTtzdHJva2UtZGFzaGFycmF5Om5vbmU7c3Ryb2tlLW9wYWNpdHk6MDtwYWludC1vcmRlcjpub3JtYWwiIHJ5PSIyNi4xNjczMjQiIHJ4PSIyNS43NDc4NjQiIGN5PSIxMjYuNTM3NzQiIGN4PSI5Mi41NjEzMDIiIC8+PC9nPjxnIHRyYW5zZm9ybT0ibWF0cml4KDAuNzU4NTUzNTksMCwwLDAuNzU4NTUzNTksMjQuMTMyNzYzLDI0LjM1ODE5MSkiPjxwYXRoIHN0eWxlPSJmaWxsOiM4ODg4ODg7c3Ryb2tlOiM4ODg4ODg7c3Ryb2tlLXdpZHRoOjEzLjA2NTtzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2UtbWl0ZXJsaW1pdDoxO3N0cm9rZS1kYXNoYXJyYXk6bm9uZTtzdHJva2Utb3BhY2l0eTowO3BhaW50LW9yZGVyOm5vcm1hbCIgZD0ibSA3NS4yMjM1NDcsOTIuNDIxNDk0IGEgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtNS45MzM0OTIsNy44MDk4NzYgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtOC4yOTg3MzIsLTQuNjk2NjYzIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgMi42MjU0MDgsLTkuNjgyMDgyIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgOS4zNDUyODYsMC44MzcxMzggbCAtNS4xNDg5NjgsNS43MzE3MzEgeiIgLz48cGF0aCBzdHlsZT0iZmlsbDojODg4ODg4O3N0cm9rZTojODg4ODg4O3N0cm9rZS13aWR0aDoxMy4wNjU7c3Ryb2tlLWxpbmVjYXA6YnV0dDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLW1pdGVybGltaXQ6MTtzdHJva2UtZGFzaGFycmF5Om5vbmU7c3Ryb2tlLW9wYWNpdHk6MDtwYWludC1vcmRlcjpub3JtYWwiIGQ9Im0gMTAyLjYyODQsODIuNjM0MDQxIGEgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtNS45MzM0OTEsNy44MDk4NzQgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtOC4yOTg3MzIsLTQuNjk2NjYxIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgMi42MjU0MDgsLTkuNjgyMDgyIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgOS4zNDUyODUsMC44MzcxMzkgbCAtNS4xNDg5NjcsNS43MzE3MyB6IiAvPjwvZz48L3N2Zz4=';

      String htmlContent = await rootBundle.loadString('assets/leaflet_map.html');

      // Set initial map center and zoom level
      String initializeMapScript = '''
        <script>
          map.setView([$latitude, $longitude], 13);
        </script>
      ''';

      String finalHtml = htmlContent.replaceFirst('</body>', initializeMapScript + '</body>');

      setState(() {
        controller.loadHtmlString(finalHtml);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void addMarker(double lat, double lng, String iconUrl) {
    print('Adding marker at lat: $lat, lng: $lng with icon: $iconUrl');
    String jsCommand = '''
      addMarker($lat, $lng, "$iconUrl");
    ''';

    controller.runJavaScript(jsCommand);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaflet Map with Current Location')),
      body: WebViewWidget(controller: controller),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const double lat = 10.681246239;
          const double long = 122.50342215;
          const String icon = 'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0ndXRmLTgnPz48c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjIwMG1tIiBoZWlnaHQ9IjIwMG1tIiB2aWV3Qm94PSI1MCA1MCAxMDAgMTAwIiB2ZXJzaW9uPSIxLjEiPjxnIHRyYW5zZm9ybT0ibWF0cml4KDAuNzU4NTUzNTksMCwwLDAuNzU4NTUzNTksMjQuMTMyNzYzLDI0LjM1ODE5MSkiPjxwYXRoIHN0eWxlPSJmaWxsOiNmZmZmZmY7c3Ryb2tlOiMwMDAwMDA7c3Ryb2tlLXdpZHRoOjEzLjA2NTtzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2UtbWl0ZXJsaW1pdDoxO3N0cm9rZS1kYXNoYXJyYXk6bm9uZTtwYWludC1vcmRlcjpub3JtYWwiIGQ9Ik0gMTY0LjcwODgsMTI0Ljk5OTcxIEMgMTYwLjI5MTUsMTUwLjgwNjA0IDgyLjUyNTc4OSwxNzkuNTUyMDEgNjIuMzg1NDk4LDE2Mi44MjMzNSA0Mi4yNDUyMDYsMTQ2LjA5NDY5IDU2LjIzMzMyMyw2NC4zNzQ2MjYgODAuNzkwOTE0LDU1LjI5Njk1MyAxMDUuMzQ4NTEsNDYuMjE5MjggMTY5LjEyNjEsOTkuMTkzMzc0IDE2NC43MDg4LDEyNC45OTk3MSBaIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtOC4zODkyNDI5LC0xMS43NDQ5NCkiIC8+PC9nPjxnIHRyYW5zZm9ybT0ibWF0cml4KDAuNzU4NTUzNTksMCwwLDAuNzU4NTUzNTksMjQuMTMyNzYzLDI0LjM1ODE5MSkiPjxlbGxpcHNlIHN0eWxlPSJmaWxsOiMwMDAwMDA7c3Ryb2tlOiMwMDAwMDA7c3Ryb2tlLXdpZHRoOjE1LjgxOTc7c3Ryb2tlLWxpbmVjYXA6YnV0dDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLW1pdGVybGltaXQ6MTtzdHJva2UtZGFzaGFycmF5Om5vbmU7c3Ryb2tlLW9wYWNpdHk6MDtwYWludC1vcmRlcjpub3JtYWwiIHJ5PSIyNi4xNjczMjQiIHJ4PSIyNS43NDc4NjQiIGN5PSIxMjYuNTM3NzQiIGN4PSI5Mi41NjEzMDIiIC8+PC9nPjxnIHRyYW5zZm9ybT0ibWF0cml4KDAuNzU4NTUzNTksMCwwLDAuNzU4NTUzNTksMjQuMTMyNzYzLDI0LjM1ODE5MSkiPjxwYXRoIHN0eWxlPSJmaWxsOiMwMDAwMDA7c3Ryb2tlOiMwMDAwMDA7c3Ryb2tlLXdpZHRoOjEzLjA2NTtzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2UtbWl0ZXJsaW1pdDoxO3N0cm9rZS1kYXNoYXJyYXk6bm9uZTtzdHJva2Utb3BhY2l0eTowO3BhaW50LW9yZGVyOm5vcm1hbCIgZD0ibSA3NS4yMjM1NDcsOTIuNDIxNDk0IGEgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtNS45MzM0OTIsNy44MDk4NzYgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtOC4yOTg3MzIsLTQuNjk2NjYzIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgMi42MjU0MDgsLTkuNjgyMDgyIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgOS4zNDUyODYsMC44MzcxMzggbCAtNS4xNDg5NjgsNS43MzE3MzEgeiIgLz48cGF0aCBzdHlsZT0iZmlsbDojMDAwMDAwO3N0cm9rZTojMDAwMDAwO3N0cm9rZS13aWR0aDoxMy4wNjU7c3Ryb2tlLWxpbmVjYXA6YnV0dDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLW1pdGVybGltaXQ6MTtzdHJva2UtZGFzaGFycmF5Om5vbmU7c3Ryb2tlLW9wYWNpdHk6MDtwYWludC1vcmRlcjpub3JtYWwiIGQ9Im0gMTAyLjYyODQsODIuNjM0MDQxIGEgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtNS45MzM0OTEsNy44MDk4NzQgNy40MTA0OTc3LDcuOTY5NzgwNCAwIDAgMSAtOC4yOTg3MzIsLTQuNjk2NjYxIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgMi42MjU0MDgsLTkuNjgyMDgyIDcuNDEwNDk3Nyw3Ljk2OTc4MDQgMCAwIDEgOS4zNDUyODUsMC44MzcxMzkgbCAtNS4xNDg5NjcsNS43MzE3MyB6IiAvPjwvZz48L3N2Zz4=';
          addMarker(lat, long, icon);
        },
        child: const Icon(Icons.add_location),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: MyWebViewPage()));
