
import 'dart:async';

import 'package:avisa_la/core/services/geolocation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TripMonitoringPage extends StatefulWidget {
  final double destinationLatitude;
  final double destinationLongitude;

  const TripMonitoringPage({
    super.key,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

  @override
  State<TripMonitoringPage> createState() => _TripMonitoringPageState();
}

class _TripMonitoringPageState extends State<TripMonitoringPage> {
  final _distanceController = TextEditingController(text: '10');
  final _geolocationService = GeolocationService();
  StreamSubscription<Map<String, dynamic>?>? _dataSubscription;

  bool _isMonitoring = false;
  double? _currentDistance;

  @override
  void initState() {
    super.initState();
    _dataSubscription = _geolocationService.onDataReceived().listen((data) {
      if (data != null && data.containsKey('distanceInKm')) {
        if (mounted) {
          setState(() {
            _currentDistance = data['distanceInKm'];
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _dataSubscription?.cancel();
    super.dispose();
  }

  void _startMonitoring() {
    FocusScope.of(context).unfocus();

    final distanceInKm = double.tryParse(_distanceController.text);
    if (distanceInKm == null || distanceInKm <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira uma distância válida.')),
      );
      return;
    }

    _geolocationService.startMonitoring(
      destinationLatitude: widget.destinationLatitude,
      destinationLongitude: widget.destinationLongitude,
      alarmDistanceKm: distanceInKm,
    );

    setState(() {
      _isMonitoring = true;
    });
  }

  void _stopMonitoring() {
    _geolocationService.stopService();
    setState(() {
      _isMonitoring = false;
      _currentDistance = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isMonitoring ? 'Monitorando Viagem' : 'Configurar Viagem'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isMonitoring)
                _buildConfigurationView()
              else
                _buildMonitoringView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigurationView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Destino: ${widget.destinationLatitude.toStringAsFixed(6)}, ${widget.destinationLongitude.toStringAsFixed(6)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _distanceController,
          decoration: const InputDecoration(
            labelText: 'Distância para o alarme (km)',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed: _startMonitoring,
          child: const Text('Iniciar Monitoramento'),
        ),
      ],
    );
  }

  Widget _buildMonitoringView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            'Distância até o destino:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            _currentDistance != null
                ? '${_currentDistance!.toStringAsFixed(2)} km'
                : 'Calculando...',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
            backgroundColor: Colors.red,
          ),
          onPressed: _stopMonitoring,
          child: const Text('Parar Monitoramento'),
        ),
      ],
    );
  }
}
