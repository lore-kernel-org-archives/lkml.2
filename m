Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1GXWIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 18:08:01 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37291 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab1GXWH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 18:07:57 -0400
From: jeffbrown@android.com
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, chatty@enac.fr, benjamin.tissoires@enac.fr,
        Jeff Brown <jeffbrown@google.com>, jeffbrown@android.com
Subject: [PATCH 3/3] hid-multitouch: Add LG Display Multitouch device.
Date: Sun, 24 Jul 2011 15:07:41 -0700
Message-Id: <1311545261-34067-3-git-send-email-jeffbrown@android.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1311545261-34067-1-git-send-email-jeffbrown@android.com>
References: <1311545261-34067-1-git-send-email-jeffbrown@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Brown <jeffbrown@google.com>

Signed-off-by: jeffbrown@android.com
---
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index db63ccf..637e6e9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -419,6 +419,9 @@
 #define USB_DEVICE_ID_LD_HYBRID		0x2090
 #define USB_DEVICE_ID_LD_HEATCONTROL	0x20A0
 
+#define USB_VENDOR_ID_LG		0x1fd2
+#define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
+
 #define USB_VENDOR_ID_LOGITECH		0x046d
 #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
 #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 4ee21ac..b03a0b0 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -682,6 +682,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
 			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
 
+	/* LG Display panels */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_LG,
+			USB_DEVICE_ID_LG_MULTITOUCH) },
+
 	/* Lumio panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
 		HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,
-- 
1.7.0.4

