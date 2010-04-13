Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0DMUHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:07:24 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:40343 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752793Ab0DMUHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:07:23 -0400
Message-ID: <4BC4CEF8.6030207@ribosome.natur.cuni.cz>
Date: Tue, 13 Apr 2010 22:07:20 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SeaMonkey/2.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.33.1: USB camera hung_task_timeout_secs >120 seconds
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I am not certain whether the stacktrace I received is just intentional
to attract developer eyes or whether this is actually a false alarm:
mounting USB mass storage device media always takes a long while.
This is a P4-M laptop with Kouwell 7004 FW/USB2.0 PCMCIA card.
Comments?
Thanks,
martin


pcmcia_socket pcmcia_socket1: pccard: CardBus card inserted into slot 1
pci 0000:07:00.0: reg 14: [mem 0x00000000-0x000000ff]
pci 0000:07:00.0: reg 20: [io  0xfce0-0xfcff]
pci 0000:07:00.0: supports D1 D2
pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:07:00.0: PME# disabled
pci 0000:07:00.1: reg 14: [mem 0x00000000-0x000000ff]
pci 0000:07:00.1: reg 20: [io  0xfce0-0xfcff]
pci 0000:07:00.1: supports D1 D2
pci 0000:07:00.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:07:00.1: PME# disabled
pci 0000:07:00.2: reg 10: [mem 0x00000000-0x000000ff]
pci 0000:07:00.2: reg 14: [mem 0x00000000-0x000000ff]
pci 0000:07:00.2: supports D1 D2
pci 0000:07:00.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:07:00.2: PME# disabled
pci 0000:07:00.3: reg 10: [mem 0x00000000-0x000007ff]
pci 0000:07:00.3: reg 14: [io  0x0000-0x007f]
pci 0000:07:00.3: supports D2
pci 0000:07:00.3: PME# supported from D2 D3hot D3cold
pci 0000:07:00.3: PME# disabled
pci 0000:07:00.3: BAR 0: assigned [mem 0x8c000000-0x8c0007ff]
pci 0000:07:00.3: BAR 0: set to [mem 0x8c000000-0x8c0007ff] (PCI address [0x8c000000-0x8c0007ff]
pci 0000:07:00.0: BAR 1: assigned [mem 0x8c000800-0x8c0008ff]
pci 0000:07:00.0: BAR 1: set to [mem 0x8c000800-0x8c0008ff] (PCI address [0x8c000800-0x8c0008ff]
pci 0000:07:00.1: BAR 1: assigned [mem 0x8c000900-0x8c0009ff]
pci 0000:07:00.1: BAR 1: set to [mem 0x8c000900-0x8c0009ff] (PCI address [0x8c000900-0x8c0009ff]
pci 0000:07:00.2: BAR 0: assigned [mem 0x8c000a00-0x8c000aff]
pci 0000:07:00.2: BAR 0: set to [mem 0x8c000a00-0x8c000aff] (PCI address [0x8c000a00-0x8c000aff]
pci 0000:07:00.2: BAR 1: assigned [mem 0x8c000b00-0x8c000bff]
pci 0000:07:00.2: BAR 1: set to [mem 0x8c000b00-0x8c000bff] (PCI address [0x8c000b00-0x8c000bff]
pci 0000:07:00.3: BAR 1: assigned [io  0xac00-0xac7f]
pci 0000:07:00.3: BAR 1: set to [io  0xac00-0xac7f] (PCI address [0xac00-0xac7f]
pci 0000:07:00.0: BAR 4: assigned [io  0xac80-0xac9f]
pci 0000:07:00.0: BAR 4: set to [io  0xac80-0xac9f] (PCI address [0xac80-0xac9f]
pci 0000:07:00.1: BAR 4: assigned [io  0xaca0-0xacbf]
pci 0000:07:00.1: BAR 4: set to [io  0xaca0-0xacbf] (PCI address [0xaca0-0xacbf]
uhci_hcd 0000:07:00.0: enabling device (0000 -> 0003)
uhci_hcd 0000:07:00.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:07:00.0: UHCI Host Controller
uhci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:07:00.0: irq 11, io base 0x0000ac80
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.33.1 uhci_hcd
usb usb3: SerialNumber: 0000:07:00.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:07:00.1: enabling device (0000 -> 0003)
uhci_hcd 0000:07:00.1: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:07:00.1: UHCI Host Controller
uhci_hcd 0000:07:00.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:07:00.1: irq 11, io base 0x0000aca0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.33.1 uhci_hcd
usb usb4: SerialNumber: 0000:07:00.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci1394 0000:07:00.3: enabling device (0080 -> 0083)
ohci1394 0000:07:00.3: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
ohci1394 0000:07:00.3: setting latency timer to 64
ohci1394: fw-host1: OHCI-1394 1.1 (PCI): IRQ=[11]  MMIO=[8c000000-8c0007ff]  Max Packet=[1024]  IR/IT contexts=[4/8]
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ehci_hcd 0000:07:00.2: enabling device (0000 -> 0002)
ehci_hcd 0000:07:00.2: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
ehci_hcd 0000:07:00.2: EHCI Host Controller
ehci_hcd 0000:07:00.2: new USB bus registered, assigned bus number 5
ehci_hcd 0000:07:00.2: irq 11, io mem 0x8c000a00
ehci_hcd 0000:07:00.2: USB 2.0 started, EHCI 1.00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: EHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.33.1 ehci_hcd
usb usb5: SerialNumber: 0000:07:00.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 4 ports detected
ieee1394: Host added: ID:BUS[1-00:1023]  GUID[00ff06ff00ff30ff]
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: New USB device found, idVendor=07b4, idProduct=0105
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 3-1: Product: C5050Z
usb 3-1: Manufacturer: OLYMPUS
usb 3-1: SerialNumber: 000242752403
usbcore: registered new interface driver libusual
Initializing USB Mass Storage driver...
scsi2 : usb-storage 3-1:1.0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi 2:0:0:0: Direct-Access     OLYMPUS  C5050Z           1.00 PQ: 0 ANSI: 2
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 2:0:0:0: timing out command, waited 180s
INFO: task async/0:6797 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
async/0       D c10184f2     0  6797      2 0x00000000
  de735da4 00000046 de735d9c c10184f2 00000000 d1202a90 7fffffff 7fffffff
  d1202a90 de735dd0 c12f6210 de735db8 c115f617 ce106400 de735dc0 c11ea443
  de735dec 7fffffff de735e88 d1202a90 de735e08 c12f6110 d1202a90 00000000
Call Trace:
  [<c10184f2>] ? complete+0x1f/0x28
  [<c12f6210>] schedule_timeout+0x17/0x109
  [<c115f617>] ? kobject_put+0x37/0x3c
  [<c11ea443>] ? put_device+0xf/0x11
  [<c12f6110>] wait_for_common+0x96/0xe3
  [<c101a883>] ? default_wake_function+0x0/0xd
  [<c12f61cf>] wait_for_completion+0x12/0x14
  [<c1157ebd>] blk_execute_rq+0x74/0x8b
  [<c1157dc0>] ? blk_end_sync_rq+0x0/0x28
  [<c1153232>] ? elv_set_request+0x12/0x20
  [<c115590d>] ? get_request+0x193/0x208
  [<c115599b>] ? get_request_wait+0x19/0xe8
  [<c11ff29e>] scsi_execute+0xbe/0x101
  [<c11ff333>] scsi_execute_req+0x52/0x7f
  [<c1208f08>] sd_revalidate_disk+0xfe/0x104c
  [<c1020000>] ? sys_gettimeofday+0xa/0x58
  [<c1209f28>] sd_probe_async+0xd2/0x1a7
  [<c102ef5f>] async_thread+0xdc/0x1b3
  [<c101ad10>] ? T.809+0x26/0x57
  [<c101a883>] ? default_wake_function+0x0/0xd
  [<c102ee83>] ? async_thread+0x0/0x1b3
  [<c102a7b5>] kthread+0x5e/0x63
  [<c102a757>] ? kthread+0x0/0x63
  [<c1002bb6>] kernel_thread_helper+0x6/0x10
sd 2:0:0:0: timing out command, waited 180s
sd 2:0:0:0: timing out command, waited 180s
sd 2:0:0:0: [sdb] Unit Not Ready
sd 2:0:0:0: [sdb] Sense Key : 0x4 [current]
sd 2:0:0:0: [sdb] ASC=0x3e ASCQ=0x1
