Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab1AEReg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:34:36 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:38902 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab1AERef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:34:35 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Davide Ammirata <webmaster@davidea.it>
Subject: [RFC v2 05/10] hid-multitouch: Add support for Cando 10.1" panels
Date: Wed,  5 Jan 2011 18:27:43 +0100
Message-Id: <1294248468-19979-6-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Davide Ammirata <webmaster@davidea.it>
---
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 17b444b..70dd0fd 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -136,6 +136,7 @@
 #define USB_VENDOR_ID_CANDO		0x2087
 #define USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH 0x0703
 #define USB_DEVICE_ID_CANDO_MULTI_TOUCH	0x0a01
+#define USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1 0x0a02
 #define USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6 0x0b03
 #define USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6 0x0f01
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 374389e..9edbf5d 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -409,6 +409,9 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
 	{ .driver_data = MT_CLS_DUAL2,
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
+			USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
+	{ .driver_data = MT_CLS_DUAL2,
+		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
 
 	{ }
-- 
1.7.3.4

