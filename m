Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1AHLPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 06:15:05 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:53656 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab1AHLPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 06:15:03 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [PATCH] HID: add Add Cando touch screen 10.1-inch product id
Date: Sat,  8 Jan 2011 12:15:41 +0100
Message-Id: <1294485342-2492-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device has been reported to be an hid-cando one.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
Hi Jiri,

This one can go into stable branch.

Cheers,
Benjamin

 drivers/hid/hid-cando.c |    2 ++
 drivers/hid/hid-core.c  |    1 +
 drivers/hid/hid-ids.h   |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-cando.c b/drivers/hid/hid-cando.c
index 375b509..1ea066c 100644
--- a/drivers/hid/hid-cando.c
+++ b/drivers/hid/hid-cando.c
@@ -236,6 +236,8 @@ static const struct hid_device_id cando_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
+			USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 		USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 04b7eb0..a397010 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1313,6 +1313,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index a945d79..9038ed3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -141,6 +141,7 @@
 
 #define USB_VENDOR_ID_CANDO		0x2087
 #define USB_DEVICE_ID_CANDO_MULTI_TOUCH	0x0a01
+#define USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1 0x0a02
 #define USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6 0x0b03
 #define USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6 0x0f01
 
-- 
1.7.3.4

