Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab2HLHmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 03:42:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39367 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2HLHl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 03:41:58 -0400
From: aborigines <7aborigines7@gmail.com>
To: marcel@holtmann.org, padovan@profusion.mobi
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        aborigines <7aborigines7@gmail.com>
Subject: [PATCH] add support bluetooth usb 0489:e046 Foxconn / Hon Hai
Date: Sun, 12 Aug 2012 14:41:44 +0700
Message-Id: <1344757304-11555-1-git-send-email-7aborigines7@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ usb-deveices
T: Bus=01 Lev=02 Prnt=02 Port=02 Cnt=03 Dev#= 5 Spd=12 MxCh= 0
D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
P: Vendor=0489 ProdID=e046 Rev=01.12
S: Manufacturer=Broadcom Corp
S: Product=BCM20702A0
S: SerialNumber=C01885F67F9E
C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

$ lsusb
Bus 001 Device 005: ID 0489:e046 Foxconn / Hon Hai
---
 drivers/bluetooth/btusb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index fc4bcd6..fb54c70 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -110,6 +110,7 @@ static struct usb_device_id btusb_table[] = {
 
 	/* Foxconn - Hon Hai */
 	{ USB_DEVICE(0x0489, 0xe033) },
+	{ USB_DEVICE(0x0489, 0xe046) },
 
 	{ }	/* Terminating entry */
 };
-- 
1.7.9.5

