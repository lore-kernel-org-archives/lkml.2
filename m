Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2AWXvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:51:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab2AWXvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:51:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:27 2012
Message-Id: <20120123234027.892986763@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [58/90] HID: multitouch: add support for the MSI Windpad 110W
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

commit 66f06127f34ad6e8a1b24a2c03144b694d19f99f upstream.

Just another eGalax device.
Please note that adding this device to have_special_driver
in hid-core.c is not required anymore.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -235,6 +235,7 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C	0x720c
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B	0x726b
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1	0x72a1
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA	0x72fa
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302	0x7302
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -648,6 +648,9 @@ static const struct hid_device_id mt_dev
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
 	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA) },
+	{ .driver_data = MT_CLS_EGALAX,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
 	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,


