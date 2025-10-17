
import 'package:avisa_la/core/services/geolocation_service.dart';
import 'package:avisa_la/core/services/permission_service.dart';
import 'package:avisa_la/features/destination_search/presentation/pages/destination_search_page.dart';
import 'package:flutter/material.dart';

void main() async {
  // Garante que a inicialização do Flutter seja concluída antes de rodar o código nativo
  WidgetsFlutterBinding.ensureInitialized();

  // Solicita as permissões necessárias
  await PermissionService().requestPermissions();

  // Inicializa o serviço de geolocalização em segundo plano
  await GeolocationService().initializeService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avisa-lá',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DestinationSearchPage(),
    );
  }
}
