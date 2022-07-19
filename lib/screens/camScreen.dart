import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rtc/const/agora.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine;
  int? uid;
  int? otherUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LIVE'),
      ),
      body: FutureBuilder(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                    child: Stack(children: [
                  renderMainView(),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          color: Colors.grey,
                          height: 160,
                          width: 120,
                          child: renderSubView()))
                ])),
                ElevatedButton(
                  onPressed: () {
                    if (engine != null) {
                      engine?.leaveChannel();
                    }

                    Navigator.of(context).pop();
                  },
                  child: Text('채널 나가기'),
                ),
              ],
            );
          }),
    );
  }

  Widget renderSubView() {
    if (otherUid == null) {
      return Center(
        child: Text("채널에 유저가 없습니다."),
      );
    } else {
      return RtcRemoteView.SurfaceView(
        uid: otherUid!,
        channelId: CHANNEL_NAME,
      );
    }
  }

  Widget renderMainView() {
    if (uid == null) {
      return Center(child: Text("채널에 참여해주세요"));
    } else {
      return RtcLocalView.SurfaceView();
    }
  }

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (engine == null) {
      RtcEngineContext context = RtcEngineContext(APP_ID);

      engine = await RtcEngine.createWithContext(context);

      engine!.setEventHandler(RtcEngineEventHandler(
          joinChannelSuccess: (String channel, int uid, int elapsed) {
        print('joinChannelSuccess: $channel, uid: $uid, elapsed: $elapsed');
        setState(() {
          this.uid = uid;
        });
      }, userJoined: (int uid, int elapsed) {
        print('userJoined: $uid, elapsed: $elapsed');
        setState(() {
          this.otherUid = uid;
        });
      }, leaveChannel: (state) {
        print("채널에서 나갔습니다.");
        setState(() {
          uid = null;
        });
      }, userOffline: (int uid, UserOfflineReason reason) {
        print("상대가 채널에서 나갔습니다");
        setState(() {
          otherUid = null;
        });
      }));

      await engine!.enableVideo();

      await engine!.joinChannel(TEMP_TOKEN, CHANNEL_NAME, null, 0);
    }

    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다.';
    }

    return true;
  }
}
