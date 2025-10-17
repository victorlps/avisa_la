
import 'package:avisa_la/features/trip_monitoring/presentation/pages/trip_monitoring_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class DestinationSearchPage extends StatefulWidget {
  const DestinationSearchPage({super.key});

  @override
  State<DestinationSearchPage> createState() => _DestinationSearchPageState();
}

class _DestinationSearchPageState extends State<DestinationSearchPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchDestination() async {
    if (_searchController.text.isEmpty) {
      return; // Não faz nada se o campo estiver vazio
    }

    // Esconde o teclado
    FocusScope.of(context).unfocus();

    try {
      final locations = await locationFromAddress(_searchController.text);
      if (!mounted) return; // Garante que o widget ainda está na árvore

      if (locations.isNotEmpty) {
        final firstLocation = locations.first;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripMonitoringPage(
              destinationLatitude: firstLocation.latitude,
              destinationLongitude: firstLocation.longitude,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhum destino encontrado.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar destino: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisa-lá'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Para onde vamos?',
                hintText: 'Ex: Rodoviária Novo Rio, Rio de Janeiro',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchDestination(), // Permite buscar com o "enter" do teclado
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchDestination,
              child: const Text('Buscar Destino'),
            ),
          ],
        ),
      ),
    );
  }
}
