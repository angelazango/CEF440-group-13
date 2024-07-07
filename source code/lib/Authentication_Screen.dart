import 'package:bio_check_in/role_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen ({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum SupportState{
  unknown,
  supported,
  unsupported,
}

class _AuthScreenState extends State<AuthScreen>{

  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState. unknown;
  List<BiometricType>? availableBiometrics;

  @override
  void initState(){
    auth.isDeviceSupported().then((bool isSupported) =>
        setState(()=> supportState = isSupported? SupportState.supported: SupportState.unsupported ));
    super.initState();
  }


  Future<void> checkBiometric() async{
    late bool canCheckBiometric;
    try{
      canCheckBiometric = await auth.canCheckBiometrics;
      print('Biometric supported: ScanCheckBiometric');
    } on PlatformException catch (e){
      print('e');
      canCheckBiometric = false;
    }
  }


  Future<void> getAvailalableBiometrics() async{
    late List<BiometricType> biometricTypes;
    try{
      biometricTypes = await auth.getAvailableBiometrics();
      print('supported biometrics $biometricTypes');
    } on PlatformException catch (e){
      print(e);
    }

    if(!mounted){
      return;
    }
    setState(() {
      availableBiometrics = biometricTypes;
    });
  }

  Future<void> authenticateWithBiometricis() async{
    try{
      final authenticated = await auth.authenticate(
          localizedReason: 'Authenticate with fingerprint or FaceID',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          )
      );
      if(!mounted){
        return;
      }

      if(authenticated){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const RoleChoicePage()));
      }
    } on PlatformException catch (e){
      print(e);
      return;
    }
  }


  @override
  Widget build(BuildContext context){
    return const Scaffold();
  }
}