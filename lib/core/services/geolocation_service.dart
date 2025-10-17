
import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

// Esta função precisa ser um função de nível superior (fora de uma classe).
// É o ponto de entrada para o serviço em segundo plano.
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Garante que os plugins possam ser usados no isolate de background.
  DartPluginRegistrant.ensureInitialized();

  // Escuta por eventos vindos da UI.
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Lógica principal de monitoramento da localização.
  service.on('startMonitoring').listen((data) async {
    if (data == null) return;

    final double destinationLatitude = data['destinationLatitude'];
    final double destinationLongitude = data['destinationLongitude'];
    final double alarmDistanceKm = data['alarmDistanceKm'];
    final alarmDistanceMeters = alarmDistanceKm * 1000;

    // Configurações para alta precisão, ideal para navegação.
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Notifica a cada 100 metros de deslocamento.
    );

    // Começa a escutar as atualizações de posição.
    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        // Calcula a distância entre a posição atual e o destino.
        final double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          destinationLatitude,
          destinationLongitude,
        );

        final double distanceInKm = distanceInMeters / 1000;

        // Envia dados de volta para a UI (se ela estiver aberta).
        service.invoke(
          'update',
          {
            "distanceInKm": distanceInKm,
          },
        );

        // Atualiza a notificação persistente.
        if (service is AndroidServiceInstance) {
          service.setForegroundNotificationInfo(
            title: "Avisa-lá: Monitorando sua viagem",
            content: "Distância restante: ${distanceInKm.toStringAsFixed(2)} km",
          );
        }

        // Verifica se a condição do alarme foi atingida.
        if (distanceInMeters <= alarmDistanceMeters) {
          print('ALERTA! Você está dentro da distância definida.');
          // TODO: Tocar um alarme de verdade.
          service.stopSelf(); // Para o serviço após o alarme.
        }
      },
      onError: (error) {
        print('Erro ao obter localização: $error');
        // TODO: Informar ao usuário sobre o erro.
      },
      cancelOnError: true,
    );
  });
}

class GeolocationService {
  final _service = FlutterBackgroundService();

  Future<void> initializeService() async {
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: false, // Não queremos que inicie junto com o app.
        notificationChannelId: 'avisa_la_notification_channel', // Obrigatório a partir do Android 8
        initialNotificationTitle: 'Avisa-lá',
        initialNotificationContent: 'Serviço de localização pronto.',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        autoStart: false,
      ),
    );
  }

  void startMonitoring({
    required double destinationLatitude,
    required double destinationLongitude,
    required double alarmDistanceKm,
  }) {
    // Inicia o serviço em background e passa os dados necessários.
    _service.startService();
    _service.invoke('startMonitoring', {
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
      'alarmDistanceKm': alarmDistanceKm,
    });
  }

  void stopService() {
    _service.invoke('stopService');
  }

  Stream<Map<String, dynamic>?> onDataReceived() {
    return _service.on('update');
  }
}
