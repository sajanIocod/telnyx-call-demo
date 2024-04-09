import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telnyx_call/main.dart';
import 'package:telnyx_call/telnyx_function.dart';

class DialPad extends StatefulWidget {
  // final void Function(String) onDial;
  final String? phoneNumber;
  final bool? fromActiveCallScreen;
  const DialPad(
      {super.key,
      // required this.onDial,
      this.phoneNumber,
      this.fromActiveCallScreen});

  @override
  DialPadState createState() => DialPadState();
}

class DialPadState extends State<DialPad> {
  String _phoneNumber = '';

  TextEditingController numController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Future.delayed(const Duration(seconds: 20), () {
      //   TelnyxConfiguration().setUpTelnyx();
      // });
      // context.read<OtpVerificationProvider>().getCountries(context);
      TelnyxConfiguration().listenCallIos();
    });
    // numController.selection =
    //     TextSelection.collapsed(offset: _phoneNumber.length);
  }

  void _onNumberPressed(String number, bool fromActiveCallScreen) {
    // numController.selection =
    //     TextSelection.collapsed(offset: _phoneNumber.length);

    if (widget.fromActiveCallScreen != null) {
      if (widget.fromActiveCallScreen!) {
        // TwilioVoice.instance.call.sendDigits(number);
      }
    }
    if (_phoneNumber.length >= 10) {
      return;
    }
    setState(() {
      _phoneNumber += number;
    });
  }

  void _onBackspacePressed() {
    ContextMenuController.removeAny();
    if (numController.selection.start != -1 &&
        numController.selection.end != -1 &&
        numController.selection.textInside(_phoneNumber).isNotEmpty) {
      setState(() {
        _phoneNumber = _phoneNumber.replaceRange(
            numController.selection.start, numController.selection.end, '');
      });
    } else {
      setState(() {
        if (_phoneNumber.isNotEmpty) {
          _phoneNumber = _phoneNumber.substring(0, _phoneNumber.length - 1);
        }
      });
    }
  }

  void _onDialPressed() async {
    // if (_phoneNumber.isNotEmpty) {
    //   // ?Todo
    //   log('Phone number  $_phoneNumber');
    // widget.onDial(_phoneNumber);
    TelnyxConfiguration().setUpTelnyx();
    setState(() {});
    await Future.delayed(const Duration(seconds: 4));
    setState(() {});

    TelnyxConfiguration().createCall(destinationNumber: _phoneNumber);
    // }
    // numController.selection =
    //     TextSelection.collapsed(offset: _phoneNumber.length);
  }

  String getFlagEmoji(String countryCode) {
    final codePoints = countryCode
        .toUpperCase()
        .split('')
        .map((char) => 127397 + char.codeUnitAt(0));
    return String.fromCharCodes(codePoints);
  }

  @override
  Widget build(BuildContext context) {
    setup();
    final theme = Theme.of(context);
    // final countries = context.read<OtpVerificationProvider>().countries;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 160),

            Theme(
              data: theme.copyWith(
                primaryColor: Colors.blue,
                textSelectionTheme: const TextSelectionThemeData(
                  selectionHandleColor: Colors.blue,
                  // selectionColor: Colors.white,
                  cursorColor: Colors.white,
                ),
              ),
              child: TextFormField(
                onChanged: (value) {},

                controller: numController..text = _phoneNumber,

                // controller: numController,
                enableInteractiveSelection: true,
                autofocus: true,
                showCursor: true,
                cursorColor: Colors.white,
                contextMenuBuilder: (context2, editableTextState) {
                  final TextEditingValue textEditingValue =
                      editableTextState.textEditingValue;

                  return AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: editableTextState.contextMenuAnchors,
                    buttonItems: [
                      ContextMenuButtonItem(
                        label: 'Cut',
                        onPressed: () {
                          ContextMenuController.removeAny();
                          Clipboard.setData(ClipboardData(
                              text: textEditingValue.selection
                                  .textInside(textEditingValue.text)));
                          _phoneNumber = _phoneNumber.replaceRange(
                              textEditingValue.selection.start,
                              textEditingValue.selection.end,
                              '');
                          log(_phoneNumber);
                          setState(() {});
                        },
                      ),
                      ContextMenuButtonItem(
                        label: 'Copy',
                        onPressed: () {
                          ContextMenuController.removeAny();
                          Clipboard.setData(ClipboardData(
                              text: textEditingValue.selection
                                  .textInside(textEditingValue.text)));
                        },
                      ),
                      ContextMenuButtonItem(
                        label: 'Paste',
                        onPressed: () {},
                      ),
                    ],
                  );
                },
                cursorHeight: 0,
                cursorWidth: 0,

                keyboardType: TextInputType.none,
                decoration: InputDecoration(
                    prefix: widget.fromActiveCallScreen ?? false
                        ? const SizedBox()
                        : const Text(
                            '  +1',
                            style: TextStyle(fontSize: 32),
                          ),
                    suffix: _buildBackspaceButton(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumberButton('1', ''),
                _buildNumberButton('2', 'ABC'),
                _buildNumberButton('3', 'DEF'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumberButton('4', 'GHI'),
                _buildNumberButton('5', 'JKL'),
                _buildNumberButton('6', 'MNO'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumberButton('7', 'PQRS'),
                _buildNumberButton('8', 'TUV'),
                _buildNumberButton('9', 'WXYZ'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumberButton('*', ''),
                _buildNumberButton('0', '+'),
                _buildNumberButton('#', ''),
              ],
            ),
            _buildDialButton(),
            // const SizedBox(
            //   height: 50,
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number, String letters) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _onNumberPressed(number, widget.fromActiveCallScreen ?? false);
        },
        onLongPress: () => _onNumberPressed(letters == '+' ? letters : '',
            widget.fromActiveCallScreen ?? false),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  number,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                // Text(
                //   letters,
                //   style: const TextStyle(fontSize: 12),
                // ),
                // SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: _onBackspacePressed,
        onLongPress: () {
          ContextMenuController.removeAny();
          setState(() {
            if (_phoneNumber.isNotEmpty) {
              _phoneNumber = '';
            }
          });
          // numController.selection =
          //     TextSelection.collapsed(offset: _phoneNumber.length);
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.backspace),
        ),
      ),
    );
  }

  Widget _buildDialButton() {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3), shape: BoxShape.circle),
      child: InkWell(
        onTap: _onDialPressed,
        borderRadius: BorderRadius.circular(40),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Icon(
            Icons.phone_outlined,
            size: 35,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
