Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab2CFJx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:53:58 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33075 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758789Ab2CFJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:53:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of benjamin.tissoires@gmail.com designates 10.216.137.147 as permitted sender) smtp.mail=benjamin.tissoires@gmail.com; dkim=pass header.i=benjamin.tissoires@gmail.com
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] HID: multitouch: add new PID from Ideacom
Date: Tue,  6 Mar 2012 10:53:46 +0100
Message-Id: <1331027628-7946-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331027628-7946-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1331027628-7946-1-git-send-email-benjamin.tissoires@gmail.com>
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
index 36664d8..e2fb977 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -374,6 +374,7 @@
 
 #define USB_VENDOR_ID_IDEACOM		0x1cb6
 #define USB_DEVICE_ID_IDEACOM_IDC6650	0x6650
+#define USB_DEVICE_ID_IDEACOM_IDC6651	0x6651
 
 #define USB_VENDOR_ID_ILITEK		0x222a
 #define USB_DEVICE_ID_ILITEK_MULTITOUCH	0x0001
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 04adb4b..1e6de67 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -825,6 +825,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_SERIAL,
 		HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
 			USB_DEVICE_ID_IDEACOM_IDC6650) },
+	{ .driver_data = MT_CLS_SERIAL,
+		HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
+			USB_DEVICE_ID_IDEACOM_IDC6651) },
 
 	/* Ilitek dual touch panel */
 	{  .driver_data = MT_CLS_DEFAULT,
-- 
1.7.7.6

