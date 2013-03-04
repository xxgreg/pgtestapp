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
      
      reply(msg) {
        request.response
          ..headers.set(HttpHeaders.CONTENT_TYPE, 'text/plain')
          ..addString(msg)
          ..close();  
      }
      
      connect('testdb', 'testdb', 'password', host: 'localhost', port: 5432)
        .then((conn) {
          reply('Connected.');
        })
        .catchError((error) {
          reply('Boom! $error');
        });
      
    });
  });
}
