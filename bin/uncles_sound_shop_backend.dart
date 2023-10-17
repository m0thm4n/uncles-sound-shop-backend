import 'package:aws_lambda_dart_runtime/aws_lambda_dart_runtime.dart';
import 'dart:io' show InternetAddress;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';
import 'dart:convert';

void main() async {
  /// This demo's handling an ALB request.
  final Handler<AwsALBEvent> helloALB = (context, event) async {
    // String username = 'uncles-assistant@duocore.dev';
    // String password = 'UnclesAssistant123!';

    // final smtpServer = SmtpServer('box.duocore.space', username: username, password: password, allowInsecure: true, ignoreBadCertificate: true);

    // Map mappedData = json.decode(context.toString());

    // // Create our message.
    // final message = Message()
    //   ..from = Address(username, 'Assistant')
    //   ..recipients.add('bob.uncleproducer@gmail.com')
    //   // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    //   // ..bccRecipients.add(Address('bccAddress@example.com'))
    //   ..subject = mappedData['subject']
    //   ..text = "From: " + mappedData['email'] + '\n\n' + mappedData['details'];
    //   // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    // try {
    //   final sendReport = send(message, smtpServer);
    //   print('Message sent: ' + sendReport.toString());
    // } on MailerException catch (e) {
    //   print('Message not sent.');
    //   for (var p in e.problems) {
    //     print('Problem: ${p.code}: ${p.msg}');
    //   }
    // }

    print(context);

    final response = '''
      <html>
      <header><title>My Lambda Function</title></header>
      <body>
      Success! I created my first Dart Lambda function.
      </body>
      </html>
    ''';
    /// Returns the response to the ALB.
    return InvocationResult(
        context.requestId!, AwsALBResponse.fromString(response));
  };
  /// The Runtime is a singleton.
  /// You can define the handlers as you wish.
  Runtime()
    ..registerHandler<AwsALBEvent>("hello.ALB", helloALB)
    ..invoke();

  // Router router = Router();

  // CORS Settings
  // const corsRequestHeaders = {
  //   'Content-Type': 'application/json',
  //   'Access-Control-Allow-Origin': '*',
  //   'Access-Control-Allow-Headers': '*',
  //   'Access-Control-Allow-Credentials': 'true',
  //   'Access-Control-Allow-Methods': 'OPTIONS,POST,DELETE',
  // };

  // router.post('/send-email', (Request request) async {
  //   await request.readAsString().then((value) {
  //     String username = 'uncles-assistant@duocore.dev';
  //     String password = 'UnclesAssistant123!';

  //     final smtpServer = SmtpServer('box.duocore.space', username: username, password: password, allowInsecure: true, ignoreBadCertificate: true);

  //     Map mappedData = json.decode(value);

  //     // Create our message.
  //     final message = Message()
  //       ..from = Address(username, 'Assistant')
  //       ..recipients.add('bob.uncleproducer@gmail.com')
  //       // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
  //       // ..bccRecipients.add(Address('bccAddress@example.com'))
  //       ..subject = mappedData['subject']
  //       ..text = "From: " + mappedData['email'] + '\n\n' + mappedData['details'];
  //       // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  //     try {
  //       final sendReport = send(message, smtpServer);
  //       print('Message sent: ' + sendReport.toString());
  //     } on MailerException catch (e) {
  //       print('Message not sent.');
  //       for (var p in e.problems) {
  //         print('Problem: ${p.code}: ${p.msg}');
  //       }
  //     }
  //   });
  //   return Response.ok("200", headers: {
  //       ...corsRequestHeaders,  // add corsHeaders to response headers of each route
  //     },);
  // });

  // final handler = const Pipeline()
  //   .addMiddleware(
  //     corsHeaders( // Middleware from 'shelf_cors_headers'
  //         headers: corsRequestHeaders,
  //     ),
  //   ).addHandler(router);

  // final server = await shelf_io.serve(
  //   handler,
  //   InternetAddress.anyIPv4,
  //   8080,
  // );

  // print('Serving at http://${server.address.host}:${server.port}');
}
