Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0LaRif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:38:35 -0500
Received: from mail.wdtv.com ([66.118.69.84]:43823 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab0LaRid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:38:33 -0500
From: gene heskett <gheskett@wdtv.com>
To: linux-bluetooth@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Something has gone aglay in the bluetooth build
Date: Fri, 31 Dec 2010 12:38:29 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8; KDE/4.5.4; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012311238.29257.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

AFAIK, std kernel build, but I am getting tons of errors when I try to 
modprobe the modules that 3 days ago, made rfcomm0 and a broadcom bt button 
work flawlessly.

But today, a sata cable failed (what else is new, I wish they would outlaw 
the importation of any far eastern cable product that uses that red dye in 
the jackets, its a damned time bomb and has been since at least 1972)

Anyway, after replacing the cable with another one just like it (snort) and 
of course doing a power down reboot to do that, my logs and screens are 
full of this sort of messages when attempting to bring this device to life.

from dmesg:

[ 2844.653595] usb 1-10.1.3: new full speed USB device using ehci_hcd and 
address 24
[ 2844.741717] usb 1-10.1.3: New USB device found, idVendor=0a5c, 
idProduct=2148
[ 2844.741721] usb 1-10.1.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[ 2844.741725] usb 1-10.1.3: Product: BCM92046DG-CL1ROM
[ 2844.741727] usb 1-10.1.3: Manufacturer: Broadcom Corp
[ 2844.741729] usb 1-10.1.3: SerialNumber: 000272A176A4
[ 2844.766545] btusb: Unknown symbol hci_free_dev (err 0)
[ 2844.767534] btusb: Unknown symbol hci_alloc_dev (err 0)
[ 2844.767957] btusb: Unknown symbol hci_unregister_dev (err 0)
[ 2844.768322] btusb: Unknown symbol hci_recv_fragment (err 0)
[ 2844.768425] btusb: Unknown symbol hci_register_dev (err 0)
[ 2844.769378] btusb: Unknown symbol hci_free_dev (err 0)
[ 2844.770397] btusb: Unknown symbol hci_alloc_dev (err 0)
[ 2844.770822] btusb: Unknown symbol hci_unregister_dev (err 0)
[ 2844.771251] btusb: Unknown symbol hci_recv_fragment (err 0)
[ 2844.771353] btusb: Unknown symbol hci_register_dev (err 0)
[ 2844.772379] btusb: Unknown symbol hci_free_dev (err 0)
[ 2844.773400] btusb: Unknown symbol hci_alloc_dev (err 0)
[ 2844.773834] btusb: Unknown symbol hci_unregister_dev (err 0)
[ 2844.774209] btusb: Unknown symbol hci_recv_fragment (err 0)
[ 2844.774314] btusb: Unknown symbol hci_register_dev (err 0)
[ 2844.777025] btusb: Unknown symbol hci_free_dev (err 0)
[ 2844.778013] btusb: Unknown symbol hci_alloc_dev (err 0)
[ 2844.778435] btusb: Unknown symbol hci_unregister_dev (err 0)
[ 2844.778807] btusb: Unknown symbol hci_recv_fragment (err 0)
[ 2844.778908] btusb: Unknown symbol hci_register_dev (err 0)
[ 3102.216439] hci_uart: Unknown symbol hci_free_dev (err 0)
[ 3102.216892] hci_uart: Unknown symbol hci_alloc_dev (err 0)
[ 3102.217244] hci_uart: Unknown symbol hci_unregister_dev (err 0)
[ 3102.217345] hci_uart: Unknown symbol hci_recv_frame (err 0)
[ 3102.217575] hci_uart: Unknown symbol hci_register_dev (err 0)
[ 3102.217688] hci_uart: Unknown symbol hci_recv_stream_fragment (err 0)

And this is a freshly rebuilt 1.5 hours ago, 2.6.37-rc8 kernel, which 
reported only a few (5)section miss-matches during the build and install.

depmod -a -e `uname -r` output is a null return.

Does anyone have a clue to spare?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
nominal egg:
	New Yorkerese for expensive.
