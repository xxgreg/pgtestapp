import 'dart:io';
import 'dart:json' as JSON;

import 'package:postgresql/postgresql.dart';

main() {
  int defaultPort = 8080;
  var portStr = Platform.environment['PORT'];
  if (portStr == null)
    portStr = "";
  var port = int.parse(portStr, onError: (_) => defaultPort);
  
  HttpServer.bind('0.0.0.0', port).then((HttpServer server){
    print('Server started on port: ${port}');
    server.listen((HttpRequest request) {
      var resp = 'oi you!';
      request.response..headers.set(HttpHeaders.CONTENT_TYPE, 'application/json')
                      ..addString(resp)
                      ..close();
    });
  });
}
