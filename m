Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0J0UUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:20:44 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:39046 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab0J0UUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:20:40 -0400
X-MXL-Hash: 4cc8899862844fa7-ef9521bd3fa8095ae336414a3b538ae418ea2b61
X-MXL-Hash: 4cc889852d816c41-257db7b05b4f20031772db081d7733bd370cc092
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Tom Vier <tom@triadsys.com>
CC: Samuel Thibault <sthibault@debian.org>,
        "594089@bugs.debian.org" <594089@bugs.debian.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Date: Wed, 27 Oct 2010 15:20:09 -0500
Subject: RE: Bug#594089: keyboard-configuration: caps lock keycode problem
Thread-Topic: Bug#594089: keyboard-configuration: caps lock keycode problem
Thread-Index: Act2DPHIpTSQV4AqQ5mqjClyxuLILgABtimw
Message-ID: <0D753D10438DA54287A00B027084269764819C63F4@AUSP01VMBX24.collaborationhost.net>
References: <20101025180320.GA4725@const.famille.thibault.fr>
 <4CC6E9D8.8010201@triadsys.com>
 <20101026161820.GE13097@core.coreip.homeip.net>
 <4CC7426C.8040502@triadsys.com>
 <20101027091029.GB28895@core.coreip.homeip.net>
 <20101027120513.GT4725@const.famille.thibault.fr>
 <99F91536-4413-430C-9932-7CEF6AB656DB@gmail.com>
 <20101027152242.GO4725@const.famille.thibault.fr>
 <20101027160842.GB8745@core.coreip.homeip.net>
 <4CC870BB.2050000@triadsys.com>
 <20101027192508.GA29761@core.coreip.homeip.net>
In-Reply-To: <20101027192508.GA29761@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010073001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.98]
X-AnalysisOut: [v=1.0 c=1 a=GyRN2M6o8M0A:10 a=BLceEmwcHowA:10 a=8nJEP1OIZ-]
X-AnalysisOut: [IA:10 a=IRTT+DMug47mVLgYdXzmDg==:17 a=QyI_JuDl0goDo4zm8eMA]
X-AnalysisOut: [:9 a=F2R33EtV1u0ws57myjR4ILlfLggA:4 a=wPNLvfGTeEIA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wednesday, October 27, 2010 12:25 PM, Dmitry Torokhov wrote:
>> 
>> I: Bus=0003 Vendor=046d Product=c30a Version=0110
>> N: Name="Logitech Logitech USB Keyboard"
>> P: Phys=usb-0000:00:13.0-2/input0
>> S: Sysfs=/devices/pci0000:00/0000:00:13.0/usb5/5-2/5-2:1.0/input/input9
>> U: Uniq=
>> H: Handlers=kbd event2
>> B: EV=120013
>> B: KEY=1000000000007 ff800000000007ff febeffdfffefffff fffffffffffffffe
>> B: MSC=10
>> B: LED=1f
>> 
>> I: Bus=0003 Vendor=046d Product=c30a Version=0110
>> N: Name="Logitech Logitech USB Keyboard"
>> P: Phys=usb-0000:00:13.0-2/input1
>> S: Sysfs=/devices/pci0000:00/0000:00:13.0/usb5/5-2/5-2:1.1/input/input10
>> U: Uniq=
>> H: Handlers=kbd mouse2 event3
>> B: EV=17
>> B: KEY=fffffffffffff f8403340000 60d8fafd01d008 1f000000000000 0
>> B: REL=103
>> B: MSC=10
>> 
>
>
> Hmm, this keyboard registers 2 input devices... I wonder, if you press
> CapsLock/Favories and RightShift/Previous and monitor both event devices
> with evtest - will it report events on both devices at once?

I haven't really been following this thread but I think the two input devices
is normal if the keyboard has multi-media keys.  All the "extra" keys show up
as a separate input device.

You might get the CapsLock and RightShift events on one device and the Favorites
and Previous events on the other.

Hartley