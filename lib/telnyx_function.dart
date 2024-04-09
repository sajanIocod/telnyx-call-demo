import 'package:telnyx_webrtc/telnyx_client.dart';
import 'package:telnyx_webrtc/telnyx_webrtc.dart';

class TelnyxConfiguration {
  final TelnyxClient _telnyxClient = TelnyxClient();

  IncomingInviteParams? _invite;
  Future<void> connect() async {
    _telnyxClient.connect();
  }

  CredentialConfig tokenConfig = CredentialConfig(
      'sreerage1712554188eg',
      '7015871194',
      'Sreerag',
      '+12098788013',
      'doZeWSVUT2yo0YJf5RCqqL:APA91bE5NbfIlGBHQIonJv239KgpjEyWvTDMO7KUcuEpXDLg4-dldz1EGqMhYRr0Uekxs9S1tOqUgpwuiHRrBbgGdrmXMBa3YCyunxBt9Bb3oY46ZLuzC0q_TrKToIgcxrkvaluA1HYg',
      true);

  void setUpTelnyx() {
    _telnyxClient.credentialLogin(tokenConfig);
    //OR

    // _telnyxClient.credentialLogin(credentialConfig);
  }

  void createCall({
    String? callerName,
    String? callerNumber,
    String? destinationNumber,
    String? destinationState,
  }) {
    _telnyxClient.call.newInvite(
        'Sreerag', '+12098788013', '+13158609852', "Fake state",
        customHeaders: {"X-Header-1": "Value1", "X-Header-2": "Value2"});
  }

  void endCall() {
    if (_telnyxClient.isConnected()) {
      _telnyxClient.call.endCall(_telnyxClient.call.callId);
    } else {
      _telnyxClient.call.endCall(_invite?.callID);
    }
  }

  void toggleMute() {
    _telnyxClient.call.onMuteUnmutePressed();
  }

  void toggleLoudSpeaker(bool enable) {
    _telnyxClient.call.enableSpeakerPhone(enable);
  }

  void toggleHold() {
    _telnyxClient.call.onHoldUnholdPressed();
  }

  listenCallIos() {
    // Observe Socket Messages Received
    _telnyxClient.onSocketMessageReceived = (TelnyxMessage message) {
      switch (message.socketMethod) {
        case SocketMethod.CLIENT_READY:
          {
            // Fires once client has correctly been setup and logged into, you can now make calls.
            break;
          }
        case SocketMethod.LOGIN:
          {
            // Handle a successful login - Update UI or Navigate to new screen, etc.
            break;
          }
        case SocketMethod.INVITE:
          {
            // Handle an invitation Update UI or Navigate to new screen, etc.
            // Then, through an answer button of some kind we can accept the call with:
            _invite = message.message.inviteParams!;
            _telnyxClient.call
                .acceptCall(_invite!, "callerName", "000000000", "State");
            break;
          }
        case SocketMethod.ANSWER:
          {
            // Handle a received call answer - Update UI or Navigate to new screen, etc.
            break;
          }
        case SocketMethod.BYE:
          {
            // Handle a call rejection or ending - Update UI or Navigate to new screen, etc.
            break;
          }
      }
    };
  }
}
