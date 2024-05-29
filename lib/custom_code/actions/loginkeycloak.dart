// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:html';

import 'package:keycloak_flutter/keycloak_flutter.dart';

Future<String?> loginkeycloak() async {
  try {
    final keycloakService = KeycloakService(KeycloakConfig(
      url: 'https://rhsso-dev.grupomateus.com.br/auth',
      realm: 'grupomateus',
      clientId: 'gmsuite',
    ));

    await keycloakService.init(
      initOptions: KeycloakInitOptions(
        onLoad: 'check-sso',
        responseMode: 'query',
        silentCheckSsoRedirectUri:
            '${window.location.origin}/silent-check-sso.html',
      ),
    );

    final isAuthenticated = await keycloakService.isLoggedIn();
    if (isAuthenticated) {
      // O usuário está logado, retorne o access token
      final accessToken = await keycloakService.getToken();
      return accessToken;
    } else {
      // Realize o login
      await keycloakService.login(KeycloakLoginOptions(
        redirectUri: '${window.location.origin}',
      ));

      // Tente novamente após o login
      final isAuthenticatedAfterLogin = await keycloakService.isLoggedIn();
      if (isAuthenticatedAfterLogin) {
        // O login foi bem-sucedido, retorne o access token
        final accessToken = await keycloakService.getToken();
        return accessToken;
      } else {
        // O login não foi bem-sucedido, retorne null
        return null;
      }
    }
  } catch (e) {
    // Lide com exceções aqui
    print('Erro: $e');
    return null;
  }
}
