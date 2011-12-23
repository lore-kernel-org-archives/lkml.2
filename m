Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab1LWOlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 09:41:47 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:55801 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1LWOlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:41:44 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 2/2] HID: multitouch: add support for 3M 32"
Date: Fri, 23 Dec 2011 15:41:00 +0100
Message-Id: <1324651260-4067-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1324651260-4067-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1324651260-4067-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 8705249..efd2fda 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -21,6 +21,7 @@
 #define USB_VENDOR_ID_3M		0x0596
 #define USB_DEVICE_ID_3M1968		0x0500
 #define USB_DEVICE_ID_3M2256		0x0502
+#define USB_DEVICE_ID_3M3266		0x0506
 
 #define USB_VENDOR_ID_A4TECH		0x09da
 #define USB_DEVICE_ID_A4TECH_WCP32PU	0x0006
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d038864..c3154af 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -661,6 +661,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_3M,
 		HID_USB_DEVICE(USB_VENDOR_ID_3M,
 			USB_DEVICE_ID_3M2256) },
+	{ .driver_data = MT_CLS_3M,
+		HID_USB_DEVICE(USB_VENDOR_ID_3M,
+			USB_DEVICE_ID_3M3266) },
 
 	/* ActionStar panels */
 	{ .driver_data = MT_CLS_DEFAULT,
-- 
1.7.4.4

