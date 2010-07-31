Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0GaOXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 10:23:34 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46331 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0GaOXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 10:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version
         :content-type;
        b=IWLKX/8RjPKkb0cA2yiI3Alhza1xflSx7DrWd7Gwr9qMz4SG7D3n972rMV3fv6Q3R4
         rKS0TrjjvSc+i4Uofc59gYXROEEmGQD88KCYk9HOWmQDMylLrQZqHDzeLb4415KgtNRs
         oK+xDSTBdGg2l7YVz/fG8LQ5vXlyHUY2q7l/8=
Date: Sat, 31 Jul 2010 22:23:33 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: usb3.0 not recognizing hard disk.
Message-ID: <Pine.LNX.4.64.1007312217240.2820@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm trying out USB3.0 and connected a hard disk enclosure with a 
known-good hard disk to an USB 3.0 express-card.

>From dmesg, it's able to recognize the card and disk, but I can't even use 
"fdisk /dev/sdb" ... what else do I need?

xhci_hcd 0000:05:00.0: enabling device (0000 -> 0002)
xhci_hcd 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
xhci_hcd 0000:05:00.0: setting latency timer to 64
xhci_hcd 0000:05:00.0: xHCI Host Controller
xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 3
xhci_hcd 0000:05:00.0: irq 19, io mem 0xf0000000
usb usb3: No SuperSpeed endpoint companion for config 1  interface 0
altsetting 0 ep 129: using minimum values
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
hub 3-0:1.0: unable to enumerate USB device on port 3
usb 3-1: new SuperSpeed USB device using xhci_hcd and address 2
xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
xhci_hcd 0000:05:00.0: WARN: short transfer on control ep

Initializing USB Mass Storage driver...
scsi7 : usb-storage 3-2:1.0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi 7:0:0:0: Direct-Access     ASMT     2105             0    PQ: 0 ANSI: 
0
sd 7:0:0:0: Attached scsi generic sg1 type 0
sd 7:0:0:0: [sdb] Attached SCSI removable disk



# here's the same disk connected to USB2.0 port showing the partition 
table and fdisk works

Initializing USB Mass Storage driver...
scsi6 : usb-storage 1-1.2:1.0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi 6:0:0:0: Direct-Access     SAMSUNG  MMDOE56G5MXP-0VB VBM1 PQ: 0 ANSI: 
0
sd 6:0:0:0: Attached scsi generic sg1 type 0
sd 6:0:0:0: [sdb] 500118192 512-byte logical blocks: (256 GB/238 GiB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 23 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] Assuming drive cache: write through
  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 sdb12 
sdb13 sdb14 sdb15 >
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] Attached SCSI disk


Thanks,
Jeff
