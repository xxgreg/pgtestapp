import 'dart:async';
import 'dart:io';
import 'dart:json' as JSON;

import 'package:postgresql/postgresql.dart';

Future<Connection> pgconnect() {
  
  var username = 'testdb';
  var database = 'testdb';
  var password = 'password';
  var host = 'localhost';
  int port = 5432;
  
  var url = Platform.environment['DATABASE_URL'];

  if (url != null) {    
    var re = new RegExp(r'^postgres://([a-zA-Z0-9\-\_]+)\:([a-zA-Z0-9\-\_]+)\@([a-zA-Z0-9\-\_\.]+)\:([0-9]+)\/([a-zA-Z0-9\-\_]+)');
    var match = re.firstMatch(url);
    if (match != null && match.groupCount == 5) {    
      username = match[1];
      password = match[2];
      host = match[3];
      port = int.parse(match[4], onError: (_) => port);
      database = match[5];
    }
  }
  
  return connect(username, database, password, host: host, port: port);
}

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
      
      pgconnect()
        .then((conn) {
          return conn.query("select 'oi you!'").toList();
        })
        .then((result) => reply('Connected: $result'))
        .catchError((error) {
          reply('Boom! $error');
        });
      
    });
  });
}
