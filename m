Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2G0VV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 17:21:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab2G0VV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 17:21:56 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: Another vendor specific ID for BCM20702A0 [0a5c:21f1]
Date: Fri, 27 Jul 2012 23:21:21 +0200
Message-Id: <1343424081-2157-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bus 002 Device 003: ID 0a5c:21f1 Broadcom Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         1
  bDeviceProtocol         1
  bMaxPacketSize0        64
  idVendor           0x0a5c Broadcom Corp.
  idProduct          0x21f1
  bcdDevice            1.12
  iManufacturer           1 Broadcom Corp
  iProduct                2 BCM20702A0
  iSerial                 3 9CB70DCFF833
  bNumConfigurations      1

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/bluetooth/btusb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index e272214..5748b15 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -97,6 +97,7 @@ static struct usb_device_id btusb_table[] = {
 	{ USB_DEVICE(0x0a5c, 0x21e3) },
 	{ USB_DEVICE(0x0a5c, 0x21e6) },
 	{ USB_DEVICE(0x0a5c, 0x21e8) },
+	{ USB_DEVICE(0x0a5c, 0x21f1) },
 	{ USB_DEVICE(0x0a5c, 0x21f3) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 
-- 
1.7.3.1

