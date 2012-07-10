Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2GJTIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:08:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51309 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2GJTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:08:04 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        Manoj Iyer <manoj.iyer@canonical.com>
Subject: [PATCH] Bluetooth: btusb: Add vendor specific ID (0a5c:21f4) BCM20702A0
Date: Tue, 10 Jul 2012 14:07:38 -0500
Message-Id: <1341947258-3929-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

Patch adds support for BCM20702A0 device id (0a5c:21f4).

usb-devices after patch was applied:
T: Bus=03 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 2 Spd=12 MxCh= 0
D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
P: Vendor=0a5c ProdID=21f4 Rev=01.12
S: Manufacturer=Broadcom Corp
S: Product=BCM20702A0
S: SerialNumber=E4D53DF154D6
C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

usb-devices before patch was applied:
T: Bus=03 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 2 Spd=12 MxCh= 0
D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
P: Vendor=0a5c ProdID=21f4 Rev=01.12
S: Manufacturer=Broadcom Corp
S: Product=BCM20702A0
S: SerialNumber=E4D53DF154D6
C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Tested-by: Chris Gagnon <chris.gagnon@canonical.com>
---
 drivers/bluetooth/btusb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 83ebb24..1ecb8e5 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -106,6 +106,7 @@ static struct usb_device_id btusb_table[] = {
 	{ USB_DEVICE(0x0a5c, 0x21e6) },
 	{ USB_DEVICE(0x0a5c, 0x21e8) },
 	{ USB_DEVICE(0x0a5c, 0x21f3) },
+	{ USB_DEVICE(0x0a5c, 0x21f4) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 
 	/* Foxconn - Hon Hai */
-- 
1.7.9.5

