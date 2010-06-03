Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab0FCF0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:26:05 -0400
Received: from mxout12.netvision.net.il ([194.90.6.37]:52304 "EHLO
	mxout12.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0FCF0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:26:00 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 01:26:00 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
Subject: [PATCH] HID: Add support to new N-trig firwmare
Date: Thu, 03 Jun 2010 08:11:44 +0300
Message-id: <48A28051AC6D7A48B64F28272458190333674B@Exchange-IL.n-trig.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-topic: [PATCH] HID: Add support to new N-trig firwmare
Thread-index: AcsC20JRj15twZPMScCchgEYSuUnhA==
From: Micki Balanga <micki@n-trig.com>
To: jkosina@suse.cz, chatty@enac.fr, dhprince-devel@yahoo.co.uk
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update hid-ids.h to support new N-trig firmware.
Product id  0x02 - 0x0A

Signed-off-by: Micki Balanga <micki@n-trig.com>
---
---
 drivers/hid/hid-core.c |    9 +++++++++
 drivers/hid/hid-ids.h  |   10 ++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index aa0f7dc..19f627a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1337,6 +1337,15 @@ static const struct hid_device_id hid_blacklist[]
= {
        { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT,
USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
        { HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY,
USB_DEVICE_ID_GENIUS_KB29E) },
        { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
+       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1) },
+       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_2) },
+       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_3) },
+       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_4) },
+       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_5) },
+       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_6) },
+       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_7) },
+       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_8) },
+       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_9) },
        { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK,
USB_DEVICE_ID_ORTEK_WKB2000) },
        { HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX,
USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
        { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6af77ed..55fbfd6 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -391,6 +391,16 @@

 #define USB_VENDOR_ID_NTRIG                0x1b96
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN   0x0001
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1 0x0002
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_2 0x0003
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_3 0x0004
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_4 0x0005
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_5 0x0006
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_6 0x0007
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_7 0x0008
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_8 0x0009
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_9 0x000A
+

 #define USB_VENDOR_ID_ONTRAK           0x0a07
 #define USB_DEVICE_ID_ONTRAK_ADU100    0x0064
-- 
1.6.3.3

