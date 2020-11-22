import 'dart:io';
import 'package:aes_crypt/aes_crypt.dart';

class EncryptionClass {
  var crypt = AesCrypt('12345678');
  String encFilepath;

  String decFilepath;

  String encryptFactory(String fileToEn) {
    crypt.setPassword('12345678');
    crypt.setOverwriteMode(AesCryptOwMode.on);

    try {
      // Encrypts fileToEn file and save encrypted file to a file with
      // '.aes' extension added. In this case it will be fileToEn.aes'.
      // It returns a path to encrypted file.
      encFilepath = crypt.encryptFileSync(fileToEn);
      print('The encryption has been completed successfully.');
      print('Encrypted file: $encFilepath');
    } on AesCryptException catch (e) {
      // It goes here if overwrite mode set as 'AesCryptFnMode.warn'
      // and encrypted file already exists.
      if (e.type == AesCryptExceptionType.destFileExists) {
        print('The encryption has been completed unsuccessfully.');
        print(e.message);
      }
    }
    return encFilepath;
  }

  String decryptFactory(String filetoDec) {
    crypt.setOverwriteMode(AesCryptOwMode.on);

    try {
      // Decrypts the file which has been just encrypted.
      // It returns a path to decrypted file.
      decFilepath = crypt.decryptFileSync(filetoDec);
      print('The decryption has been completed successfully.');
      print('Decrypted file 1: $decFilepath');
    } on AesCryptException catch (e) {
      // It goes here if the file naming mode set as AesCryptFnMode.warn
      // and decrypted file already exists.
      if (e.type == AesCryptExceptionType.destFileExists) {
        print('The decryption has been completed unsuccessfully.');
        print(e.message);
      }
    }
    return decFilepath;
  }
}
