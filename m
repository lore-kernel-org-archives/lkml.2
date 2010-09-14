Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0INWcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:32:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34530 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab0INWcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version
         :content-type;
        b=w6JmHXWJvmDU5WkRgmQAWPq6UR85zLkBQugEKhnh4b7zqKrOPZhVXV5+AqDs6O4UnO
         m7QUdQqNAjyZvKcJAVezsVVb0DkCBayHrl575vA7MeLih7nBqa96w60CTcnnXVMH1OJj
         EItOg1iwKtUCeAxIQKJag1H/pIus6F2VPoOLo=
Date: Wed, 15 Sep 2010 06:32:22 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Wu Fengguang <fengguang.wu@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        alsa-announce@lists.sourceforge.net
Subject: Microphone not working on PCI ID 8086:3b56
Message-ID: <Pine.LNX.4.64.1009150615510.4515@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm having problem getting the microphone to work on the Lenovo X201s, but 
the audio output is working fine.


It's showing up as:

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High 
Definition Audio (rev 06)
 	[00:1b.0 0403: 8086:3b56 (rev 06)]


# uname -s
Linux boston 2.6.36-rc4 #57 SMP PREEMPT Tue Sep 14 05:12:21 EDT 2010 
x86_64 GNU/Linux


# cat /proc/asound/devices
   0: [ 0]   : control
  16: [ 0- 0]: digital audio playback
  24: [ 0- 0]: digital audio capture
  33:        : timer
160: [ 5]   : control


# cat /proc/asound/pcm
00-00: CONEXANT Analog : CONEXANT Analog : playback 1 : capture 1


# dmesg
thinkpad_acpi: Console audio control enabled, mode: override (read/write)
input: ThinkPad Extra Buttons as 
/devices/platform/thinkpad_acpi/input/input6
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda-codec: No codec parser is available
ALSA device list:
   #0: HDA Intel at 0xf2520000 irq 45
   #5: ThinkPad Console Audio Control at EC reg 0x30, fw 6QHT29WW-1.10



I've alsa-plugins-1.0.23, alsa-utils-1.0.23, alsa-lib-1.0.23 installed.

alsamixer is showing Capture at 100%, Analog Mic Boost at 40db and Digital 
at 100, but captured using "arecord" or "rec" and then playback is all 
just dead silence!

Any pointers on how to make this work would be very much appreciated.


Thanks,
Jeff
