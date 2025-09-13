/*
* @Author:Jiten Basnet on 05/05/2023
* @Company: GTEN SOFTWARE PVT.LTD.
*/

import 'dart:async';

import 'package:flutter_gcaptcha_v3/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaHandler {
  RecaptchaHandler._();

  static RecaptchaHandler? _instance;

  WebViewController? _controller;
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  final Completer<void> _recaptchaReadyCompleter = Completer<void>();

  late String _siteKey;
  String? _captchaToken;

  String get siteKey => _siteKey;
  String? get captchaToken => _captchaToken;

  static RecaptchaHandler get instance => _instance ??= RecaptchaHandler._();

  void recaptchaReady() {
    if (!_recaptchaReadyCompleter.isCompleted) {
      _recaptchaReadyCompleter.complete();
    }
  }

  updateController({required WebViewController controller}) {
    _instance?._controller = controller;

    if (!_instance!._controllerCompleter.isCompleted) {
      _instance!._controllerCompleter.complete(controller);
    }

    controller.runJavaScript(
        '${AppConstants.readyCaptcha}("${_instance?._siteKey}", "submit")');
  }

  void updateToken({required String generatedToken}) {
    _captchaToken = generatedToken;
  }

  setupSiteKey({required String dataSiteKey}) =>
      _instance?._siteKey = dataSiteKey;

  static Future<void> executeV3({String? action}) async {
    final String userAction = action ?? 'submit';

    final WebViewController controller =
        await _instance!._controllerCompleter.future;

    await _instance!._recaptchaReadyCompleter.future;

    controller.runJavaScript(
        '${AppConstants.executeCaptcha}("${_instance?._siteKey}", "$userAction")');
  }
}
