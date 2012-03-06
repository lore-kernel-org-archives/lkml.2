Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab2CFJyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:54:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60532 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482Ab2CFJxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:53:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of benjamin.tissoires@gmail.com designates 10.180.90.212 as permitted sender) smtp.mail=benjamin.tissoires@gmail.com; dkim=pass header.i=benjamin.tissoires@gmail.com
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] HID: multitouch: add new PID from Atmel product
Date: Tue,  6 Mar 2012 10:53:45 +0100
Message-Id: <1331027628-7946-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 5a8a53d..36664d8 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -148,6 +148,7 @@
 
 #define USB_VENDOR_ID_ATMEL		0x03eb
 #define USB_DEVICE_ID_ATMEL_MULTITOUCH	0x211c
+#define USB_DEVICE_ID_ATMEL_MXT_DIGITIZER	0x2118
 
 #define USB_VENDOR_ID_AVERMEDIA		0x07ca
 #define USB_DEVICE_ID_AVER_FM_MR800	0xb800
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 387a72f..04adb4b 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -740,6 +740,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_SERIAL,
 		HID_USB_DEVICE(USB_VENDOR_ID_ATMEL,
 			USB_DEVICE_ID_ATMEL_MULTITOUCH) },
+	{ .driver_data = MT_CLS_SERIAL,
+		HID_USB_DEVICE(USB_VENDOR_ID_ATMEL,
+			USB_DEVICE_ID_ATMEL_MXT_DIGITIZER) },
 
 	/* Cando panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
-- 
1.7.7.6

