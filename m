Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab2AXDBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:01:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab2AXCq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:46:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:31 2012
Message-Id: <20120124023931.213958441@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [082/129] HID: multitouch: cleanup with eGalax PID definitions
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 4658
Lines: 102

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

commit e36f690b37945e0a9bb1554e1546eeec93f7d1f6 upstream.

This is just a renaming of USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH{N}
to USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_{PID} to handle more eGalax
devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c       |   12 ++++++------
 drivers/hid/hid-ids.h        |   12 ++++++------
 drivers/hid/hid-multitouch.c |   24 ++++++++++++------------
 3 files changed, 24 insertions(+), 24 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1404,12 +1404,12 @@ static const struct hid_device_id hid_ha
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
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -645,26 +645,26 @@ static const struct hid_device_id mt_dev
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


