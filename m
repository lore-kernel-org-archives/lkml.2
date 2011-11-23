Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1KWKG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:06:28 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:37757 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1KWKG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:06:26 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] hid-multitouch: add support for the MSI Windpad 110W
Date: Wed, 23 Nov 2011 10:54:33 +0100
Message-Id: <1322042074-3759-8-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just another eGalax device.
Please note that adding this device to have_special_driver
in hid-core.c is not required anymore.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index fc49ab3..cf8c866 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -235,6 +235,7 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C	0x720c
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B	0x726b
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1	0x72a1
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA	0x72fa
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302	0x7302
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 8e920cd..77210d6 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -701,6 +701,9 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
 	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA) },
+	{ .driver_data = MT_CLS_EGALAX,
+		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
 	{ .driver_data = MT_CLS_EGALAX,
 		HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
-- 
1.7.4.4

