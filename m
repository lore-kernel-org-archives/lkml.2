Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2AXDAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:00:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528Ab2AXCqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:46:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:31 2012
Message-Id: <20120124023931.302693220@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marek Vasut <marek.vasut@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [083/129] HID: multitouch: Add egalax ID for Acer Iconia W500
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2202
Lines: 52

From: Marek Vasut <marek.vasut@gmail.com>

commit bb9ff21072043634f147c05ac65dbf8185d4af6d upstream.

This patch adds USB ID for the touchpanel in Acer Iconia W500. The panel
supports up to five fingers, therefore the need for a new addition of panel
types.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |    3 +++
 3 files changed, 5 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1409,6 +1409,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2515) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -235,6 +235,7 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C	0x720c
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B	0x726b
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1	0x72a1
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302	0x7302
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 
 #define USB_VENDOR_ID_ELECOM		0x056e
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -664,6 +664,9 @@ static const struct hid_device_id mt_dev
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
 	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
+	{ .driver_data = MT_CLS_EGALAX,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
 
 	/* Elo TouchSystems IntelliTouch Plus panel */


