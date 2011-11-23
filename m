Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849Ab1KWKB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:01:59 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:41682 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766Ab1KWKB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:01:29 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] HID: cleanup with eGalax PID definitions
Date: Wed, 23 Nov 2011 10:54:31 +0100
Message-Id: <1322042074-3759-6-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a renaming of USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH{N}
to USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_{PID} to handle more eGalax
devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-core.c       |   12 ++++++------
 drivers/hid/hid-ids.h        |   12 ++++++------
 drivers/hid/hid-multitouch.c |   24 ++++++++++++------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eb26af4..b776bfb 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1404,12 +1404,12 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, 0x0006) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, 0x0011) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH3) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH4) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH5) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480D) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480E) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2515) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EMS, USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 33c26d5..a9526fd 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -230,12 +230,12 @@
 
 #define USB_VENDOR_ID_DWAV		0x0eef
 #define USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER	0x0001
-#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH	0x480d
-#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1	0x720c
-#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2	0x72a1
-#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH3	0x480e
-#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH4	0x726b
-#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH5	0xa001
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480D	0x480d
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480E	0x480e
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C	0x720c
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B	0x726b
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1	0x72a1
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 354a5cd..db39228 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -682,26 +682,26 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 
 	/* eGalax devices (resistive) */
-	{  .driver_data = MT_CLS_EGALAX,
+	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH) },
-	{  .driver_data = MT_CLS_EGALAX,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480D) },
+	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH3) },
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_480E) },
 
 	/* eGalax devices (capacitive) */
-	{  .driver_data = MT_CLS_EGALAX,
+	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
-	{  .driver_data = MT_CLS_EGALAX,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C) },
+	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2) },
-	{  .driver_data = MT_CLS_EGALAX,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B) },
+	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH4) },
-	{  .driver_data = MT_CLS_EGALAX,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
+	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH5) },
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
 
 	/* Elo TouchSystems IntelliTouch Plus panel */
 	{ .driver_data = MT_CLS_DUAL_NSMU_CONTACTID,
-- 
1.7.4.4

