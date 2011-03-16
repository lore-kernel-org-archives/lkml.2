Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1CPWSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 18:18:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56538 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1CPWSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 18:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:mime-version:content-type
         :message-id;
        b=bNAR08P7vZAb4cg5BeNpjQcdVMbA3mZCHpEIormTliJI1nNxJkaJHRMFVu4N0OHpzI
         rk7nbwyAXPj9cJaciRot2I9rWpee0UdHka59nGMS+/CcjQE6sMcjSDVnYM7BgCLTsuYF
         V4sCEZ8H4cnhuALLgm6fDilPKmSj5ABj8RAVo=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: linux-kernel@vger.kernel.org
Subject: [b43] usb device disconnects automatically after 1s
Date: Thu, 17 Mar 2011 00:18:31 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4cTgN6pQ/LUeyOr"
Message-Id: <201103170018.32061.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_4cTgN6pQ/LUeyOr
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I have just upgraded to 2.6.38 and discovered that I can't use my wireless
device (BCM4312 802.11a/b/g). I press Fn + F2, the bluetooth led lights
and after a second it turns off by itself. In dmesg I'm seeing the followin=
g:

[   88.167212] usb 1-2.2: new full speed USB device using ehci_hcd and addr=
ess 5
[   88.782330] usb 1-2.2: USB disconnect, address 5

I switched to 2.6.37 until I'll have some time to bisect this. In the mean
time I have attached the output of lspci, interrupts and dmesg.

Thanks,

=2D-=20
Mihai Don=C8=9Bu

--Boundary-00=_4cTgN6pQ/LUeyOr
Content-Type: application/x-gzip;
  name="dmesg.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dmesg.txt.gz"

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

--Boundary-00=_4cTgN6pQ/LUeyOr
Content-Type: text/plain;
  charset="UTF-8";
  name="interrupts.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="interrupts.txt"

           CPU0       CPU1       
  0:     185247          0   IO-APIC-edge      timer
  1:       3764          0   IO-APIC-edge      i8042
  8:         18          0   IO-APIC-edge      rtc0
  9:          3          0   IO-APIC-fasteoi   acpi
 12:        106          0   IO-APIC-edge      i8042
 14:      28675          0   IO-APIC-edge      ata_piix
 15:       4047          0   IO-APIC-edge      ata_piix
 16:      30275          0   IO-APIC-fasteoi   i915
 17:      27542          0   IO-APIC-fasteoi   eth0, b43
 19:         31          0   IO-APIC-fasteoi   firewire_ohci, yenta
 20:         60          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 22:      16401          0   IO-APIC-fasteoi   uhci_hcd:usb4
 23:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 40:        391          0   PCI-MSI-edge      hda_intel
NMI:          0          0   Non-maskable interrupts
LOC:     202224     259238   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RES:     123639     198860   Rescheduling interrupts
CAL:       1252       1055   Function call interrupts
TLB:       3962       2590   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          5          5   Machine check polls
ERR:          1
MIS:          0

--Boundary-00=_4cTgN6pQ/LUeyOr
Content-Type: text/plain;
  charset="UTF-8";
  name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci.txt"

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
	Subsystem: Dell Device 01d4
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=09 <?>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
	Subsystem: Dell Device 01d4
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at eff00000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at eff8 [size=8]
	Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Memory at efec0000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 2
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: Dell Device 01d4
	Flags: bus master, fast devsel, latency 0
	Memory at eff80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 2

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
	Subsystem: Dell Device 01d4
	Flags: bus master, fast devsel, latency 0, IRQ 40
	Memory at efebc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
	Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: e4000000-e41fffff
	Prefetchable memory behind bridge: 00000000e4200000-00000000e43fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Dell Device 01d4
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: efd00000-efdfffff
	Prefetchable memory behind bridge: 00000000e4400000-00000000e45fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Dell Device 01d4
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Device 01d4
	Flags: bus master, medium devsel, latency 0, IRQ 20
	I/O ports at bf80 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Device 01d4
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at bf60 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Device 01d4
	Flags: bus master, medium devsel, latency 0, IRQ 22
	I/O ports at bf40 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Device 01d4
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at bf20 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: Dell Device 01d4
	Flags: bus master, medium devsel, latency 0, IRQ 20
	Memory at ffa80000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=06, sec-latency=32
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: efc00000-efcfffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000e3ffffff
	Capabilities: [50] Subsystem: Dell Device 01d4

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 01)
	Subsystem: Dell Device 01d4
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 01) (prog-if 80 [Master])
	Subsystem: Dell Device 01d4
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 17
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at bfa0 [size=16]
	Capabilities: [70] Power Management version 2
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
	Subsystem: Dell Device 01d4
	Flags: medium devsel, IRQ 17
	I/O ports at 10c0 [size=32]
	Kernel driver in use: i801_smbus

02:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
	Subsystem: Dell Device 01d4
	Flags: bus master, fast devsel, latency 64, IRQ 17
	Memory at efcfe000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [40] Power Management version 2
	Kernel driver in use: b44

02:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
	Subsystem: Dell Device 01d4
	Flags: bus master, stepping, slow devsel, latency 168, IRQ 19
	Memory at efc00000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
	Memory window 0: e0000000-e3fff000 (prefetchable)
	Memory window 1: e8000000-ebfff000
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus

02:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02) (prog-if 10 [OHCI])
	Subsystem: Dell Device 01d4
	Flags: bus master, medium devsel, latency 64, IRQ 19
	Memory at efcfd000 (32-bit, non-prefetchable) [size=4K]
	Memory at efcfc800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [60] Power Management version 2
	Kernel driver in use: firewire_ohci

0c:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev 01)
	Subsystem: Dell Wireless 1490 Dual Band WLAN Mini-Card
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at efdfc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 2
	Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Express Legacy Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Virtual Channel
	Kernel driver in use: b43-pci-bridge


--Boundary-00=_4cTgN6pQ/LUeyOr--
