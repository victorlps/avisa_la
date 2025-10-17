
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> requestPermissions() async {
    // Solicita permissão de notificação
    await Permission.notification.request();

    // Solicita permissão de localização
    final locationStatus = await Permission.location.request();

    // Se a localização principal for concedida, solicita a permissão em segundo plano
    if (locationStatus.isGranted) {
      await Permission.locationAlways.request();
    }
  }
}
