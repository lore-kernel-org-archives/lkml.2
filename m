Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0LPJxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:53:48 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60410 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931Ab0LPJxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:53:45 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Nauber <richard.nauber@googlemail.com>,
        Richard Nauber <Richard.Nauber@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] hid: egalax: Add support for Samsung NB30 netbook
Date: Thu, 16 Dec 2010 10:52:55 +0100
Message-Id: <1292493175-21630-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.2.3
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTAWE-0007dL-3U.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PTAWE-0007dL-3U f7c0d1a2181a77d44df192f2be518ff1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Nauber <richard.nauber@googlemail.com>

The Samsung NB30 touch has a DWAV dual-touch device. This patch adds
the NB30 to the list of supported devices, and grabs it accordingly in
hid-core.

[rydberg@euromail.se: rename and log message changes]
Signed-off-by: Richard Nauber <Richard.Nauber@gmail.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Jiri,

do I have your ACK on this one?

Thanks,
Henrik

 drivers/hid/hid-core.c   |    1 +
 drivers/hid/hid-egalax.c |    2 ++
 drivers/hid/hid-ids.h    |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9762de5..f4a37f8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1301,6 +1301,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH3) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EZKEY, USB_DEVICE_ID_BTC_8193) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR) },
diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index e367cb2..8787850 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -240,6 +240,8 @@ static const struct hid_device_id egalax_devices[] = {
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH3) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, egalax_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b76166a..a95719b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -197,6 +197,7 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH	0x480d
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1	0x720c
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH2	0x72a1
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH3	0x480e
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
-- 
1.7.2.3

