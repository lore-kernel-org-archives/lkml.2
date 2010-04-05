Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0DEUz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:55:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44288 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab0DEUzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tssuiYVSXjZq6UCZ00R/AYwfYlIG7WnvSZ1cdZxjsrvbcsfu79H/kXAZax9pfrwnvJ
         TSKvfa4WvpHja6GpNxKLR5sjJjhZIU5o531+qqe4DHA0rxOZXnPpEDaFCs7NK5mfrZCW
         Q3tBgHxT9WQA6SVuP5rA3Vcd5p33JOR8cynnA=
MIME-Version: 1.0
Date: Mon, 5 Apr 2010 13:55:52 -0700
Message-ID: <x2w5bdc1c8b1004051355o3f803c75t2515ef46320e00bd@mail.gmail.com>
Subject: Failed to initialize MSI interrupts && ioremap reserve_memtype failed 
	-22
From: Mark Knecht <markknecht@gmail.com>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   New hardware and I haven't seen these messages before so I thought
I'd post them. System is AMD64 2.6.33-gentoo,  i7-920, Intel DX58SO
Extreme Series X58

   I think the first one has maybe happened before with other e1000e
devices? The second one I don't know about.

   If anyone needs info or wants me to try something easy (I'm not a
developer) please get in touch.

- Mark


Apr  5 18:57:42 k2 kernel: rtc0: alarms up to one month, y3k, 114
bytes nvram, hpet irqs
Apr  5 18:57:42 k2 kernel: e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
Apr  5 18:57:42 k2 kernel: e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
Apr  5 18:57:42 k2 kernel: e1000e 0000:00:19.0: PCI INT A -> GSI 20
(level, low) -> IRQ 20
Apr  5 18:57:42 k2 kernel: e1000e 0000:00:19.0: setting latency timer to 64
Apr  5 18:57:42 k2 kernel: 0000:00:19.0: 0000:00:19.0: Failed to
initialize MSI interrupts.  Falling back to legacy interrupts.
Apr  5 18:57:42 k2 kernel: ehci_hcd: USB 2.0 'Enhanced' Host
Controller (EHCI) Driver
Apr  5 18:57:42 k2 kernel: uhci_hcd: USB Universal Host Controller
Interface driver
Apr  5 18:57:42 k2 kernel: firewire_ohci: Added fw-ohci device
0000:07:03.0, OHCI version 1.10
Apr  5 18:57:42 k2 kernel: 0000:00:19.0: eth0: (PCI
Express:2.5GB/s:Width x1) 00:1c:c0:b1:9a:fd
Apr  5 18:57:42 k2 kernel: 0000:00:19.0: eth0: Intel(R) PRO/1000
Network Connection
Apr  5 18:57:42 k2 kernel: 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No:
ffffff-0ff


Apr  5 11:06:28 k2 ntpd[3461]: synchronized to 208.53.158.34, stratum 2
Apr  5 11:07:50 k2 rc-scripts: status:  stopped
Apr  5 11:07:56 k2 kernel: ioremap reserve_memtype failed -22
Apr  5 11:10:01 k2 cron[4018]: (root) CMD (test -x /usr/sbin/run-crons
&& /usr/sbin/run-crons )
Apr  5 11:14:44 k2 groupadd[18342]: new group: name=scanner, GID=1006
Apr  5 11:19:30 k2 ntpd[3461]: synchronized to 74.88.39.232, stratum 2


k2 ~ # lspci
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
k2 ~ #

k2 ~ # lsmod
Module                  Size  Used by
ipv6                  207757  30
usbhid                 21529  0
nvidia              10611606  22
snd_hda_codec_realtek   239530  1
snd_hda_intel          17688  0
snd_hda_codec          45755  2 snd_hda_codec_realtek,snd_hda_intel
snd_pcm                58104  2 snd_hda_intel,snd_hda_codec
uhci_hcd               18047  0
ehci_hcd               30854  0
e1000e                111701  0
snd_timer              15030  1 snd_pcm
rtc_cmos                7678  0
processor              23121  0
sg                     23029  0
firewire_ohci          20022  0
rtc_core               11093  1 rtc_cmos
snd                    37476  5
snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
firewire_core          36109  1 firewire_ohci
usbcore               115023  4 usbhid,uhci_hcd,ehci_hcd
rtc_lib                 1617  1 rtc_core
thermal                11650  0
agpgart                24341  1 nvidia
soundcore                800  1 snd
snd_page_alloc          5809  2 snd_hda_intel,snd_pcm
k2 ~ #
