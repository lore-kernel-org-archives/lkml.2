Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1EFN7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:59:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57982 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1EFN7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:59:42 -0400
Message-ID: <4DC3FEC7.6050503@sieker.io>
Date: Fri, 06 May 2011 15:59:35 +0200
From: "Adi J. Sieker" <adi@core.adi.io>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
        USB list <linux-usb@vger.kernel.org>, linux-input@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
References: <Pine.LNX.4.44L0.1105030945410.2085-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1105061456320.28291@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1105061456320.28291@pobox.suse.cz>
Content-Type: multipart/mixed;
 boundary="------------010300010103040903040002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010300010103040903040002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/05/11 14:58, Jiri Kosina wrote:
> On Tue, 3 May 2011, Alan Stern wrote:
>
>>> Do you know of a way for me to tell the kernel/usbhid to use interface 1
>>> and ignore interface 0?
>>
>> Well, you can always unbind interface 0 from usbhid -- it corresponds
>> to the 2-1.1:1.0 file in /sys/bus/usb/drivers/usbhid/.  If you do that,
>> you'll probably find the few keys which _do_ currently work suddenly
>> stop working.
>>
>> But there's nothing to be done immediately about interface 1; usbhid is
>> _already_ using it.  It just isn't using it correctly.
>
> Adi,
>
> could you please provide output of
>
> 	cat /syse/kernel/debug/hid/<keyboard>/rdesc
>
> anytime after the keyboard has been plugged, and

in /sys/kernel/debug/hid I have two devices for the keyboard. One is 
0003:060B:0230.0002 and the other 0003:060B:0230.0003

attached are the rdesc files for both devices.

>
> 	cat /syse/kernel/debug/hid/<keyboard>/events
 > from the time you press any of the working and non-working keys? (both
 > cases will be interesting).

I only get events for the working keys on the *:0002 device.
All other files were empty after I pressed some keys.

The events for the working keys are attached in the *.events file.
I first pressed backspace and then the menu key.

Cheers
    Adi

--------------010300010103040903040002
Content-Type: text/plain;
 name="0003:060B:0230.0002.rdesc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003:060B:0230.0002.rdesc"

05 01 09 06 a1 01 05 07 19 e0 29 e7 15 00 25 01 75 01 95 08 81 02 95 01 75 08 81 01 95 03 75 01 05 08 19 01 29 03 91 02 95 05 75 01 91 01 95 06 75 08 26 ff 00 05 07 19 00 29 91 81 00 09 00 15 00 26 ff 00 75 08 95 08 b1 00 c0 

  INPUT[INPUT]
    Field(0)
      Usage(8)
        Keyboard.00e0
        Keyboard.00e1
        Keyboard.00e2
        Keyboard.00e3
        Keyboard.00e4
        Keyboard.00e5
        Keyboard.00e6
        Keyboard.00e7
      Logical Minimum(0)
      Logical Maximum(1)
      Report Size(1)
      Report Count(8)
      Report Offset(0)
      Flags( Variable Absolute )
    Field(1)
      Usage(146)
        Keyboard.0000
        Keyboard.0001
        Keyboard.0002
        Keyboard.0003
        Keyboard.0004
        Keyboard.0005
        Keyboard.0006
        Keyboard.0007
        Keyboard.0008
        Keyboard.0009
        Keyboard.000a
        Keyboard.000b
        Keyboard.000c
        Keyboard.000d
        Keyboard.000e
        Keyboard.000f
        Keyboard.0010
        Keyboard.0011
        Keyboard.0012
        Keyboard.0013
        Keyboard.0014
        Keyboard.0015
        Keyboard.0016
        Keyboard.0017
        Keyboard.0018
        Keyboard.0019
        Keyboard.001a
        Keyboard.001b
        Keyboard.001c
        Keyboard.001d
        Keyboard.001e
        Keyboard.001f
        Keyboard.0020
        Keyboard.0021
        Keyboard.0022
        Keyboard.0023
        Keyboard.0024
        Keyboard.0025
        Keyboard.0026
        Keyboard.0027
        Keyboard.0028
        Keyboard.0029
        Keyboard.002a
        Keyboard.002b
        Keyboard.002c
        Keyboard.002d
        Keyboard.002e
        Keyboard.002f
        Keyboard.0030
        Keyboard.0031
        Keyboard.0032
        Keyboard.0033
        Keyboard.0034
        Keyboard.0035
        Keyboard.0036
        Keyboard.0037
        Keyboard.0038
        Keyboard.0039
        Keyboard.003a
        Keyboard.003b
        Keyboard.003c
        Keyboard.003d
        Keyboard.003e
        Keyboard.003f
        Keyboard.0040
        Keyboard.0041
        Keyboard.0042
        Keyboard.0043
        Keyboard.0044
        Keyboard.0045
        Keyboard.0046
        Keyboard.0047
        Keyboard.0048
        Keyboard.0049
        Keyboard.004a
        Keyboard.004b
        Keyboard.004c
        Keyboard.004d
        Keyboard.004e
        Keyboard.004f
        Keyboard.0050
        Keyboard.0051
        Keyboard.0052
        Keyboard.0053
        Keyboard.0054
        Keyboard.0055
        Keyboard.0056
        Keyboard.0057
        Keyboard.0058
        Keyboard.0059
        Keyboard.005a
        Keyboard.005b
        Keyboard.005c
        Keyboard.005d
        Keyboard.005e
        Keyboard.005f
        Keyboard.0060
        Keyboard.0061
        Keyboard.0062
        Keyboard.0063
        Keyboard.0064
        Keyboard.0065
        Keyboard.0066
        Keyboard.0067
        Keyboard.0068
        Keyboard.0069
        Keyboard.006a
        Keyboard.006b
        Keyboard.006c
        Keyboard.006d
        Keyboard.006e
        Keyboard.006f
        Keyboard.0070
        Keyboard.0071
        Keyboard.0072
        Keyboard.0073
        Keyboard.0074
        Keyboard.0075
        Keyboard.0076
        Keyboard.0077
        Keyboard.0078
        Keyboard.0079
        Keyboard.007a
        Keyboard.007b
        Keyboard.007c
        Keyboard.007d
        Keyboard.007e
        Keyboard.007f
        Keyboard.0080
        Keyboard.0081
        Keyboard.0082
        Keyboard.0083
        Keyboard.0084
        Keyboard.0085
        Keyboard.0086
        Keyboard.0087
        Keyboard.0088
        Keyboard.0089
        Keyboard.008a
        Keyboard.008b
        Keyboard.008c
        Keyboard.008d
        Keyboard.008e
        Keyboard.008f
        Keyboard.0090
        Keyboard.0091
      Logical Minimum(0)
      Logical Maximum(255)
      Report Size(8)
      Report Count(6)
      Report Offset(16)
      Flags( Array Absolute )
  OUTPUT[OUTPUT]
    Field(0)
      Usage(3)
        LED.NumLock
        LED.CapsLock
        LED.ScrollLock
      Logical Minimum(0)
      Logical Maximum(1)
      Report Size(1)
      Report Count(3)
      Report Offset(0)
      Flags( Variable Absolute )
  FEATURE[FEATURE]
    Field(0)
      Usage(8)
        Keyboard.0000
        Keyboard.0000
        Keyboard.0000
        Keyboard.0000
        Keyboard.0000
        Keyboard.0000
        Keyboard.0000
        Keyboard.0000
      Logical Minimum(0)
      Logical Maximum(255)
      Report Size(8)
      Report Count(8)
      Report Offset(0)
      Flags( Array Absolute )

Keyboard.00e0 ---> Key.LeftControl
Keyboard.00e1 ---> Key.LeftShift
Keyboard.00e2 ---> Key.LeftAlt
Keyboard.00e3 ---> Key.LeftMeta
Keyboard.00e4 ---> Key.RightCtrl
Keyboard.00e5 ---> Key.RightShift
Keyboard.00e6 ---> Key.RightAlt
Keyboard.00e7 ---> Key.RightMeta
Keyboard.0000 ---> Sync.Report
Keyboard.0001 ---> Sync.Report
Keyboard.0002 ---> Sync.Report
Keyboard.0003 ---> Sync.Report
Keyboard.0004 ---> Key.A
Keyboard.0005 ---> Key.B
Keyboard.0006 ---> Key.C
Keyboard.0007 ---> Key.D
Keyboard.0008 ---> Key.E
Keyboard.0009 ---> Key.F
Keyboard.000a ---> Key.G
Keyboard.000b ---> Key.H
Keyboard.000c ---> Key.I
Keyboard.000d ---> Key.J
Keyboard.000e ---> Key.K
Keyboard.000f ---> Key.L
Keyboard.0010 ---> Key.M
Keyboard.0011 ---> Key.N
Keyboard.0012 ---> Key.O
Keyboard.0013 ---> Key.P
Keyboard.0014 ---> Key.Q
Keyboard.0015 ---> Key.R
Keyboard.0016 ---> Key.S
Keyboard.0017 ---> Key.T
Keyboard.0018 ---> Key.U
Keyboard.0019 ---> Key.V
Keyboard.001a ---> Key.W
Keyboard.001b ---> Key.X
Keyboard.001c ---> Key.Y
Keyboard.001d ---> Key.Z
Keyboard.001e ---> Key.1
Keyboard.001f ---> Key.2
Keyboard.0020 ---> Key.3
Keyboard.0021 ---> Key.4
Keyboard.0022 ---> Key.5
Keyboard.0023 ---> Key.6
Keyboard.0024 ---> Key.7
Keyboard.0025 ---> Key.8
Keyboard.0026 ---> Key.9
Keyboard.0027 ---> Key.0
Keyboard.0028 ---> Key.Enter
Keyboard.0029 ---> Key.Esc
Keyboard.002a ---> Key.Backspace
Keyboard.002b ---> Key.Tab
Keyboard.002c ---> Key.Space
Keyboard.002d ---> Key.Minus
Keyboard.002e ---> Key.Equal
Keyboard.002f ---> Key.LeftBrace
Keyboard.0030 ---> Key.RightBrace
Keyboard.0031 ---> Key.BackSlash
Keyboard.0032 ---> Key.BackSlash
Keyboard.0033 ---> Key.Semicolon
Keyboard.0034 ---> Key.Apostrophe
Keyboard.0035 ---> Key.Grave
Keyboard.0036 ---> Key.Comma
Keyboard.0037 ---> Key.Dot
Keyboard.0038 ---> Key.Slash
Keyboard.0039 ---> Key.CapsLock
Keyboard.003a ---> Key.F1
Keyboard.003b ---> Key.F2
Keyboard.003c ---> Key.F3
Keyboard.003d ---> Key.F4
Keyboard.003e ---> Key.F5
Keyboard.003f ---> Key.F6
Keyboard.0040 ---> Key.F7
Keyboard.0041 ---> Key.F8
Keyboard.0042 ---> Key.F9
Keyboard.0043 ---> Key.F10
Keyboard.0044 ---> Key.F11
Keyboard.0045 ---> Key.F12
Keyboard.0046 ---> Key.SysRq
Keyboard.0047 ---> Key.ScrollLock
Keyboard.0048 ---> Key.Pause
Keyboard.0049 ---> Key.Insert
Keyboard.004a ---> Key.Home
Keyboard.004b ---> Key.PageUp
Keyboard.004c ---> Key.Delete
Keyboard.004d ---> Key.End
Keyboard.004e ---> Key.PageDown
Keyboard.004f ---> Key.Right
Keyboard.0050 ---> Key.Left
Keyboard.0051 ---> Key.Down
Keyboard.0052 ---> Key.Up
Keyboard.0053 ---> Key.NumLock
Keyboard.0054 ---> Key.KPSlash
Keyboard.0055 ---> Key.KPAsterisk
Keyboard.0056 ---> Key.KPMinus
Keyboard.0057 ---> Key.KPPlus
Keyboard.0058 ---> Key.KPEnter
Keyboard.0059 ---> Key.KP1
Keyboard.005a ---> Key.KP2
Keyboard.005b ---> Key.KP3
Keyboard.005c ---> Key.KP4
Keyboard.005d ---> Key.KP5
Keyboard.005e ---> Key.KP6
Keyboard.005f ---> Key.KP7
Keyboard.0060 ---> Key.KP8
Keyboard.0061 ---> Key.KP9
Keyboard.0062 ---> Key.KP0
Keyboard.0063 ---> Key.KPDot
Keyboard.0064 ---> Key.102nd
Keyboard.0065 ---> Key.Compose
Keyboard.0066 ---> Key.Power
Keyboard.0067 ---> Key.KPEqual
Keyboard.0068 ---> Key.F13
Keyboard.0069 ---> Key.F14
Keyboard.006a ---> Key.F15
Keyboard.006b ---> Key.F16
Keyboard.006c ---> Key.F17
Keyboard.006d ---> Key.F18
Keyboard.006e ---> Key.F19
Keyboard.006f ---> Key.F20
Keyboard.0070 ---> Key.F21
Keyboard.0071 ---> Key.F22
Keyboard.0072 ---> Key.F23
Keyboard.0073 ---> Key.F24
Keyboard.0074 ---> Key.Open
Keyboard.0075 ---> Key.Help
Keyboard.0076 ---> Key.Props
Keyboard.0077 ---> Key.Front
Keyboard.0078 ---> Key.Stop
Keyboard.0079 ---> Key.Again
Keyboard.007a ---> Key.Undo
Keyboard.007b ---> Key.Cut
Keyboard.007c ---> Key.Copy
Keyboard.007d ---> Key.Paste
Keyboard.007e ---> Key.Find
Keyboard.007f ---> Key.Mute
Keyboard.0080 ---> Key.VolumeUp
Keyboard.0081 ---> Key.VolumeDown
Keyboard.0082 ---> Key.Unknown
Keyboard.0083 ---> Key.Unknown
Keyboard.0084 ---> Key.Unknown
Keyboard.0085 ---> Key.KPComma
Keyboard.0086 ---> Key.Unknown
Keyboard.0087 ---> Key.RO
Keyboard.0088 ---> Key.Katakana/Hiragana
Keyboard.0089 ---> Key.Yen
Keyboard.008a ---> Key.Henkan
Keyboard.008b ---> Key.Muhenkan
Keyboard.008c ---> Key.KPJpComma
Keyboard.008d ---> Key.Unknown
Keyboard.008e ---> Key.Unknown
Keyboard.008f ---> Key.Unknown
Keyboard.0090 ---> Key.Hangeul
Keyboard.0091 ---> Key.Hanja
LED.NumLock ---> LED.NumLock
LED.CapsLock ---> LED.CapsLock
LED.ScrollLock ---> LED.ScrollLock

--------------010300010103040903040002
Content-Type: application/octet-stream;
 name="0003:060B:0230.0002-working-keys.events"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0003:060B:0230.0002-working-keys.events"

CnJlcG9ydCAoc2l6ZSA4KSAodW5udW1iZXJlZCkKAHJlcG9ydCAwIChzaXplIDgpID0gACAw
MAAgMDAAIDJhACAwMAAgMDAAIDAwACAwMAAgMDAACgBLZXlib2FyZC4wMGUwID0gMAoAS2V5
Ym9hcmQuMDBlMSA9IDAKAEtleWJvYXJkLjAwZTIgPSAwCgBLZXlib2FyZC4wMGUzID0gMAoA
S2V5Ym9hcmQuMDBlNCA9IDAKAEtleWJvYXJkLjAwZTUgPSAwCgBLZXlib2FyZC4wMGU2ID0g
MAoAS2V5Ym9hcmQuMDBlNyA9IDAKAEtleWJvYXJkLjAwMmEgPSAxCgAKcmVwb3J0IChzaXpl
IDgpICh1bm51bWJlcmVkKQoAcmVwb3J0IDAgKHNpemUgOCkgPSAAIDAwACAwMAAgMDAAIDAw
ACAwMAAgMDAAIDAwACAwMAAKAEtleWJvYXJkLjAwZTAgPSAwCgBLZXlib2FyZC4wMGUxID0g
MAoAS2V5Ym9hcmQuMDBlMiA9IDAKAEtleWJvYXJkLjAwZTMgPSAwCgBLZXlib2FyZC4wMGU0
ID0gMAoAS2V5Ym9hcmQuMDBlNSA9IDAKAEtleWJvYXJkLjAwZTYgPSAwCgBLZXlib2FyZC4w
MGU3ID0gMAoAS2V5Ym9hcmQuMDAyYSA9IAAwCgAKcmVwb3J0IChzaXplIDgpICh1bm51bWJl
cmVkKQoAcmVwb3J0IDAgKHNpemUgOCkgPSAAIDAwACAwMAAgNjUAIDAwACAwMAAgMDAAIDAw
ACAwMAAKAEtleWJvYXJkLjAwZTAgPSAwCgBLZXlib2FyZC4wMGUxID0gMAoAS2V5Ym9hcmQu
MDBlMiA9IDAKAEtleWJvYXJkLjAwZTMgPSAwCgBLZXlib2FyZC4wMGU0ID0gMAoAS2V5Ym9h
cmQuMDBlNSA9IDAKAEtleWJvYXJkLjAwZTYgPSAwCgBLZXlib2FyZC4wMGU3ID0gMAoAS2V5
Ym9hcmQuMDA2NSA9IDEKAApyZXBvcnQgKHNpemUgOCkgKHVubnVtYmVyZWQpCgByZXBvcnQg
MCAoc2l6ZSA4KSA9IAAgMDAAIDAwACAwMAAgMDAAIDAwACAwMAAgMDAAIDAwAAoAS2V5Ym9h
cmQuMDBlMCA9IDAKAEtleWJvYXJkLjAwZTEgPSAwCgBLZXlib2FyZC4wMGUyID0gMAoAS2V5
Ym9hcmQuMDBlMyA9IDAKAEtleWJvYXJkLjAwZTQgPSAwCgBLZXlib2FyZC4wMGU1ID0gMAoA
S2V5Ym9hcmQuMDBlNiA9IDAKAEtleWJvYXJkLjAwZTcgPSAwCgBLZXlib2FyZC4wMDY1ACA9
IDAKAA==
--------------010300010103040903040002
Content-Type: text/plain;
 name="0003:060B:0230.0003.rdesc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003:060B:0230.0003.rdesc"

05 01 09 80 a1 01 85 01 19 81 29 83 15 00 25 01 95 03 75 01 81 02 95 01 75 05 81 01 c0 05 0c 09 01 a1 01 85 02 19 00 2a ff 7f 15 00 26 ff 7f 95 01 75 10 81 00 c0 05 01 09 06 a1 01 85 03 95 38 75 01 15 00 25 01 05 07 19 e0 29 e7 19 00 29 2f 81 02 c0 05 01 09 06 a1 01 85 04 95 38 75 01 15 00 25 01 05 07 19 30 29 67 81 02 c0 

  INPUT(1)[INPUT]
    Field(0)
      Usage(3)
        GenericDesktop.SystemPowerDown
        GenericDesktop.SystemSleep
        GenericDesktop.SystemWakeUp
      Logical Minimum(0)
      Logical Maximum(1)
      Report Size(1)
      Report Count(3)
      Report Offset(0)
      Flags( Variable Absolute )

GenericDesktop.SystemPowerDown ---> Sync.Report
GenericDesktop.SystemSleep ---> Sync.Report
GenericDesktop.SystemWakeUp ---> Sync.Report

--------------010300010103040903040002--
