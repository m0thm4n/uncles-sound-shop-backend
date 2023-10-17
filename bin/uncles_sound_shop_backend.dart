import 'package:uncles_sound_shop_backend/uncles_sound_shop_backend.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' show Router;
import 'dart:io' show InternetAddress;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';
import 'dart:convert';

Future main() async {
  Router router = Router();

  // CORS Settings
  const corsRequestHeaders = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Allow-Methods': 'OPTIONS,POST,DELETE',
  };

  router.post('/send-email', (Request request) async {
    await request.readAsString().then((value) {
      String username = 'uncles-assistant@duocore.dev';
      String password = 'UnclesAssistant123!';

      final smtpServer = SmtpServer('box.duocore.space', username: username, password: password, allowInsecure: true, ignoreBadCertificate: true);

      Map mappedData = json.decode(value);

      // Create our message.
      final message = Message()
        ..from = Address(username, 'Assistant')
        ..recipients.add('bob.uncleproducer@gmail.com')
        // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
        // ..bccRecipients.add(Address('bccAddress@example.com'))
        ..subject = mappedData['subject']
        ..text = "From: " + mappedData['email'] + '\n\n' + mappedData['details'];
        // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

      try {
        final sendReport = send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    });
    return Response.ok("200", headers: {
        ...corsRequestHeaders,  // add corsHeaders to response headers of each route
      },);
  });

  final handler = const Pipeline()
    .addMiddleware(
      corsHeaders( // Middleware from 'shelf_cors_headers'
          headers: corsRequestHeaders,
      ),
    ).addHandler(router);

  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    8080,
  );

  print('Serving at http://${server.address.host}:${server.port}');
}
