Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1EBUuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:50:03 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:63556 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1EBUuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 16:50:00 -0400
Message-ID: <4DBF18F2.80103@sieker.io>
Date: Mon, 02 May 2011 22:49:54 +0200
From: "Adi J. Sieker" <adi@core.adi.io>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: USB list <linux-usb@vger.kernel.org>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
References: <Pine.LNX.4.44L0.1105021622510.2106-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105021622510.2106-100000@iolanthe.rowland.org>
Content-Type: multipart/mixed;
 boundary="------------080000090500070705090107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080000090500070705090107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 02/05/11 22:27, Alan Stern wrote:
> On Mon, 2 May 2011, Adi J. Sieker wrote:
>
>>> Something else that might help is a usbmon trace showing what happens
>>> when you plug in the keyboard.  Instructions are in the kernel source
>>> file Documentation/usb/usbmon.txt.  In particular, while running the
>>> test try pressing some of the normal keys that don't work.
>>>
>>
>> The attached file usbmon-working.out is the output when I pressed the
>> backspace key. When I press any of the non working keys which is
>> everything but the backspace and menu key. I don't get any output even
>> when using 0u.
>
> Sorry, I wasn't clear enough.  I meant for you to start the usbmon
> trace _before_ plugging in the keyboard, so we can see what happens as
> the keyboard is initialized and probed.
>

You were clear enough, I just couldn't read. :)

Attached is the usbmon trace when I plug the keyboard in.

lsusb shows the keyboard as:
Bus 002 Device 008: ID 060b:0230 Solid Year

Relevant section from /sys/kernel/debug/usb/devices
T:  Bus=02 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  8 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=060b ProdID=0230 Rev= 2.20
S:  Manufacturer=KB
S:  Product=USB Keyboard
C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=10ms


Cheers
    Adi

--------------080000090500070705090107
Content-Type: text/plain;
 name="usbmon.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="usbmon.out"

f7290780 1275690550 C Ii:2:002:1 0:2048 2 = 0200
f7290780 1275690564 S Ii:2:002:1 -115:2048 2 <
ed799a80 1275690577 S Ci:2:002:0 s a3 00 0000 0001 0004 4 <
ed799a80 1275690733 C Ci:2:002:0 0 4 = 01010100
ed799a80 1275690760 S Co:2:002:0 s 23 01 0010 0001 0000 0
ed799a80 1275690874 C Co:2:002:0 0 0
ed799a80 1275690896 S Co:2:002:0 s 23 03 0016 0001 0000 0
ed799a80 1275690994 C Co:2:002:0 0 0
ed799a80 1275691013 S Ci:2:002:0 s a3 00 0000 0001 0004 4 <
ed799a80 1275691108 C Ci:2:002:0 0 4 = 01010000
ed799a80 1275721328 S Ci:2:002:0 s a3 00 0000 0001 0004 4 <
ed799a80 1275721498 C Ci:2:002:0 0 4 = 01010000
ed799a80 1275753292 S Ci:2:002:0 s a3 00 0000 0001 0004 4 <
ed799a80 1275753488 C Ci:2:002:0 0 4 = 01010000
ed799a80 1275785291 S Ci:2:002:0 s a3 00 0000 0001 0004 4 <
ed799a80 1275785487 C Ci:2:002:0 0 4 = 01010000
ed799a80 1275817293 S Ci:2:002:0 s a3 00 0000 0001 0004 4 <
ed799a80 1275817494 C Ci:2:002:0 0 4 = 01010000
ed799a80 1275817523 S Co:2:002:0 s 23 03 0004 0001 0000 0
ed799a80 1275817611 C Co:2:002:0 0 0
ed799a80 1275833290 S Ci:2:002:0 s a3 00 0000 0001 0004 4 <
ed799a80 1275833487 C Ci:2:002:0 0 4 = 03031000
ed799a80 1275889293 S Co:2:002:0 s 23 01 0014 0001 0000 0
ed799a80 1275889496 C Co:2:002:0 0 0
ed799a80 1275889532 S Ci:2:000:0 s 80 06 0100 0000 0040 64 <
ed799a80 1275892102 C Ci:2:000:0 0 18 = 12011001 00000008 0b063002 20020102 0001
ed799a80 1275892117 S Co:2:002:0 s 23 03 0004 0001 0000 0
ed799a80 1275892202 C Co:2:002:0 0 0
ed799a80 1275909792 S Ci:2:002:0 s a3 00 0000 0001 0004 4 <
ed799a80 1275910014 C Ci:2:002:0 0 4 = 03031000
f7290780 1275946520 C Ii:2:002:1 0:2048 2 = 0200
f7290780 1275946525 S Ii:2:002:1 -115:2048 2 <
ed799a80 1275965292 S Co:2:002:0 s 23 01 0014 0001 0000 0
ed799a80 1275965488 C Co:2:002:0 0 0
ed799a80 1275965498 S Co:2:000:0 s 00 05 0008 0000 0000 0
ed799a80 1275966256 C Co:2:000:0 0 0
ed799a80 1275985295 S Ci:2:008:0 s 80 06 0100 0000 0012 18 <
ed799a80 1275988172 C Ci:2:008:0 0 18 = 12011001 00000008 0b063002 20020102 0001
ed799a80 1275988197 S Ci:2:008:0 s 80 06 0200 0000 0009 9 <
ed799a80 1275990297 C Ci:2:008:0 0 9 = 09023b00 020100a0 32
ed799a80 1275990322 S Ci:2:008:0 s 80 06 0200 0000 003b 59 <
ed799a80 1275996802 C Ci:2:008:0 0 59 = 09023b00 020100a0 32090400 00010301 01000921 10010001 224b0007 05810308
ed799a80 1275996831 S Ci:2:008:0 s 80 06 0300 0000 00ff 255 <
ed799a80 1275998034 C Ci:2:008:0 0 4 = 04030904
ed799a80 1275998059 S Ci:2:008:0 s 80 06 0302 0409 00ff 255 <
ed799a80 1276001661 C Ci:2:008:0 0 26 = 1a035500 53004200 20004b00 65007900 62006f00 61007200 6400
ed799a80 1276001690 S Ci:2:008:0 s 80 06 0301 0409 00ff 255 <
ed799a80 1276002925 C Ci:2:008:0 0 6 = 06034b00 4200
ed799a80 1276003106 S Co:2:008:0 s 00 09 0001 0000 0000 0
ed799a80 1276004260 C Co:2:008:0 0 0
ed799a80 1276004420 S Co:2:008:0 s 21 0a 0000 0000 0000 0
ed799a80 1276005203 C Co:2:008:0 0 0
ed799a80 1276005225 S Ci:2:008:0 s 81 06 2200 0000 004b 75 <
ed799a80 1276013206 C Ci:2:008:0 0 75 = 05010906 a1010507 19e029e7 15002501 75019508 81029501 75088101 95037501
ee1bd480 1276013657 S Co:2:008:0 s 21 09 0200 0000 0001 1 = 00
ee1bd280 1276013838 S Ii:2:008:1 -115:8 8 <
ee1bdb00 1276014194 S Co:2:008:0 s 21 0a 0000 0001 0000 0
ee1bd480 1276014952 C Co:2:008:0 0 1 >
ee1bdb00 1276015579 C Co:2:008:0 -32 0
ee1bdb00 1276015635 S Ci:2:008:0 s 81 06 2200 0001 006c 108 <
ee1bdb00 1276026705 C Ci:2:008:0 0 108 = 05010980 a1018501 19812983 15002501 95037501 81029501 75058101 c0050c09
ee11ad80 1276027069 S Ci:2:002:0 s a3 00 0000 0001 0004 4 <
ee11ad80 1276027199 C Ci:2:002:0 0 4 = 03030000
ee1bd480 1276051645 S Co:2:008:0 s 21 09 0200 0000 0001 1 = 01
ee1bd480 1276052955 C Co:2:008:0 0 1 >

--------------080000090500070705090107--
