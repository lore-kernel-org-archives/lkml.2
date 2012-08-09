Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2HIGe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:34:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62452 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2HIGex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:34:53 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: multitouch: Add support for eGalax 0x73f7
Date: Thu,  9 Aug 2012 08:34:48 +0200
Message-Id: <1344494088-3438-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.4
X-Provags-ID: V02:K0:Ppq/B/JCOf2fmlQJGzMNdduj9Ow9DPu2+3CL3uwgJMA
 gjo0PVBCwTC6z/ktZSOStT1k1vprbUBo2IZ/rahlryMa7ChqH4
 xHZnaWFd0Y2wafsVmtNtdEwK8g1LGMLXso43z22azQP9JoshmD
 sed9WhnQKKXcBAVEyWVADrXxYVEzKLoIR3jZPiQT+yjLTWrNrL
 aIdiNQXllzAG7v9F/YBuHmWXAzMr7jjBx8BkOrfRx6XU67uFG5
 EKIFyREfrwqc1MjnsW5DNTxqhCXMUEoWPHCNnaoDJVbuYX3NxR
 Z9sPnKJjfziag+TImgJ+582PsL8VqB50+gQW7mm8Wim59V0KvC
 4x4Pn9pQYCaefztvpPtLC/HotmQXVu9YphyBPRR1tngw9WdOmJ
 ofRNFgkvQgv76/J69MEobL3h3+b1i8SU2FsPNL8ttP1dFXoz2X
 +z9C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 5a91bf6..9614a65 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -270,6 +270,7 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA	0x72fa
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302	0x7302
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349	0x7349
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_73F7	0x73f7
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 
 #define USB_VENDOR_ID_ELECOM		0x056e
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 59c8b5c..115dca2 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -885,6 +885,9 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349) },
 	{ .driver_data = MT_CLS_EGALAX_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_73F7) },
+	{ .driver_data = MT_CLS_EGALAX_SERIAL,
+		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
 
 	/* Elo TouchSystems IntelliTouch Plus panel */
-- 
1.7.11.4

