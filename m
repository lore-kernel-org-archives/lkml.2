Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0C2Doc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 23:44:32 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:60222 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0C2Dob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 23:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=W12V1LLlmlRuSo/pJJQYhHv5Zrkg7fpW01oS4a3YXCLQDzBj1Z80tJibx9X7ueO/Vw
         /kuwUfPlRodA/hmdN5fUvW/bioPRNWgS2N2Hhq9P5qFfxYYDdQiX6NcJ8up2rnrFX7B2
         m/eyaCf9BAUJrcvoVpDeKM9NceqFlchZKAEJs=
MIME-Version: 1.0
Date: Sun, 28 Mar 2010 20:44:30 -0700
Message-ID: <5bdc1c8b1003282044s23347905mfca7c41c37db6f18@mail.gmail.com>
Subject: 100%wa for long periods of time
From: Mark Knecht <markknecht@gmail.com>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00504502c7049d53840482e854af
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502c7049d53840482e854af
Content-Type: text/plain; charset=UTF-8

Hi all,
   Long time lurker. Seldom post here. I'm not a programmer.

   OK, so I'm bring up new hardware - Intel i7 920, Intel DX58SO
motherboard, 6GB Crucial triple channel DRAM. Using both the Gentoo
install CD (2.6.32 based) as well as 2.6.33-gentoo after booting the
install I am running into long periods of time - sometimes 30 seconds,
sometimes lasting minutes, where the machine appears to hang or slow
down very drastically. The only thing I've noticed so far is that
there are 100% waiting periods showing up in top. No messages in dmesg
or /var/log/messages. Just long periods where the the compiler acts
like the system has really slowed down and sometimes appears almost
completely dead.

   When this clears up then the system screams along building
software. When it happens is see things like the following where CPU's
1 & 5 sit at 100% waiting which lasted 2 or 3 minutes before clearing
up. The CPU that goes to 100% does move around but it does seem to
land on #5 more than others.

keeper ~ # top

top - 02:27:17 up 28 min,  2 users,  load average: 2.76, 1.95, 1.30
Tasks: 125 total,   1 running, 124 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu5  :  0.0%us,  0.3%sy,  0.0%ni,  0.0%id, 99.7%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.3%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   6107024k total,  1448676k used,  4658348k free,   187492k buffers
Swap:  4200988k total,        0k used,  4200988k free,   915900k cached


keeper ~ # lspci
00:00.0 Host bridge: Intel Corporation X58 I/O Hub to ESI Port (rev 13)
00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 1 (rev 13)
00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 3 (rev 13)
00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 7 (rev 13)
00:10.0 PIC: Intel Corporation 5520/5500/X58 Physical and Link Layer
Registers Port 0 (rev 13)
00:10.1 PIC: Intel Corporation 5520/5500/X58 Routing and Protocol
Layer Registers Port 0 (rev 13)
00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management
Registers (rev 13)
00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch
Pad Registers (rev 13)
00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status
and RAS Registers (rev 13)
00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 13)
00:19.0 Ethernet controller: Intel Corporation 82567LM-2 Gigabit
Network Connection
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
Audio Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 1
00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 2
00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 5
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
AHCI Controller
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
02:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce
9500 GT] (rev a1)
06:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II
Controller (rev b2)
07:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
IEEE-1394a-2000 Controller (PHY/Link)
keeper ~ #

keeper ~ # uname -a
Linux keeper 2.6.33-gentoo #1 SMP PREEMPT Mon Mar 29 01:12:08 PDT 2010
x86_64 Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux
keeper ~ #

keeper ~ # lsmod
Module                  Size  Used by
ipv6                  207757  24
usbhid                 21529  0
snd_hda_codec_realtek   239530  1
uhci_hcd               18047  0
ehci_hcd               30854  0
usbcore               115023  4 usbhid,uhci_hcd,ehci_hcd
sg                     23029  0
snd_hda_intel          17688  0
snd_hda_codec          45755  2 snd_hda_codec_realtek,snd_hda_intel
firewire_ohci          20022  0
e1000e                111701  0
snd_pcm                58104  2 snd_hda_intel,snd_hda_codec
processor              23121  0
rtc_cmos                7678  0
snd_timer              15030  1 snd_pcm
rtc_core               11093  1 rtc_cmos
snd                    37476  5
snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
soundcore                800  1 snd
snd_page_alloc          5809  2 snd_hda_intel,snd_pcm
firewire_core          36109  1 firewire_ohci
rtc_lib                 1617  1 rtc_core
thermal                11650  0
keeper ~ #

Thanks,
Mark

--00504502c7049d53840482e854af
Content-Type: application/x-gzip; name="config.gz"
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g7cq9n1l0

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
--00504502c7049d53840482e854af--
