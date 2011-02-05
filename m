Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1BETZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:25:06 -0500
Received: from mail001.aei.ca ([206.123.6.130]:50815 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab1BETZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:25:04 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Feb 2011 14:25:03 EST
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org
Subject: [BUG] usb problems in .38-rc3+
Date: Sat, 5 Feb 2011 14:17:57 -0500
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc3-crc+; KDE/4.6.0; x86_64; ; )
Cc: linux-bluetooth@vger.kernel.org, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102051417.58953.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My bluetooth usb dongle has stopped working in .38-rc3+

Bus 002 Device 008: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)

and in dmesg

[108495.369056] usb 5-1: new full speed USB device using ohci_hcd and address 3
[108495.573077] usb 5-1: New USB device found, idVendor=0a12, idProduct=0001
[108495.580099] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[108652.971977] usb 5-1: USB disconnect, address 3
[108652.972718] btusb_bulk_complete: hci0 urb ffff8800684e99c0 failed to resubmit (19)
[108652.973725] btusb_bulk_complete: hci0 urb ffff8800684e9c00 failed to resubmit (19)
[108652.974707] btusb_intr_complete: hci0 urb ffff8800684e9840 failed to resubmit (19)
[108653.001690] btusb_send_frame: hci0 urb ffff8800bb42a240 submission failed
[108657.007541] usb 2-4.7: new full speed USB device using ehci_hcd and address 8
[108657.147736] usb 2-4.7: New USB device found, idVendor=0a12, idProduct=0001
[108657.154954] usb 2-4.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0

Its been working for years here.

Any ideas on what to try or additional info to gather?

TIA
Ed Tomlinson

