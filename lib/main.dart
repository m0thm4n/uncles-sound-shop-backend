import 'dart:io';

import 'package:aws_lambda_dart_runtime/aws_lambda_dart_runtime.dart';
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() async {
  /// This demo's handling an API Gateway request.
  final Handler<AwsApiGatewayEvent> emailServiceApiGateway = (context, event) async {
     final resp = {
    'message': 'Hello to ${context.requestId}',
    'host': '${event.headers.host}',
    'userAgent': '${event.headers.userAgent}',
    };
    
    String username = 'uncles-assistant@duocore.dev';
    String password = 'UnclesAssistant123!';

    final smtpServer = SmtpServer('box.duocore.space', username: username, password: password, allowInsecure: true, ignoreBadCertificate: true);

    Map mappedData = json.decode(event.body);

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

    final response = AwsApiGatewayResponse(
      body: json.encode(resp),
      isBase64Encoded: false,
      statusCode: HttpStatus.ok,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Allow-Methods': 'OPTIONS,POST,DELETE',
      },
    );

    return response;
  };

  /// The Runtime is a singleton. You can define the handlers as you wish.
  Runtime()
    ..registerHandler<AwsApiGatewayEvent>("main.mail", emailServiceApiGateway)
    ..invoke();
}
