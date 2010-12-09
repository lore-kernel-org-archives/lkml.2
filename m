Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0LIUFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:05:35 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:45592 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757124Ab0LIUFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:05:31 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: Move input MT header inside input directory
Date: Thu,  9 Dec 2010 21:05:17 +0100
Message-Id: <1291925117-22042-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PQmjx-0007tK-Cn.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PQmjx-0007tK-Cn 80c9d15b050db07773d8654410da9ab5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a clean-up, rename the input-mt.h header to
input/mt.h. The patch contains no functional changes.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-3m-pct.c                 |    2 +-
 drivers/hid/hid-egalax.c                 |    2 +-
 drivers/input/input-mt.c                 |    2 +-
 drivers/input/input.c                    |    2 +-
 drivers/input/misc/uinput.c              |    2 +-
 drivers/input/tablet/wacom_wac.c         |    2 +-
 drivers/input/touchscreen/wacom_w8001.c  |    2 +-
 include/linux/{input-mt.h => input/mt.h} |    0
 8 files changed, 7 insertions(+), 7 deletions(-)
 rename include/linux/{input-mt.h => input/mt.h} (100%)

diff --git a/drivers/hid/hid-3m-pct.c b/drivers/hid/hid-3m-pct.c
index f984f0f..c32b9fe 100644
--- a/drivers/hid/hid-3m-pct.c
+++ b/drivers/hid/hid-3m-pct.c
@@ -19,7 +19,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
-#include <linux/input-mt.h>
+#include <linux/input/mt.h>
 
 MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
 MODULE_DESCRIPTION("3M PCT multitouch panels");
diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index d1919bf..5795969 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -18,7 +18,7 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/usb.h>
-#include <linux/input-mt.h>
+#include <linux/input/mt.h>
 #include <linux/slab.h>
 #include "usbhid/usbhid.h"
 
diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index c33d3ee..afaf059 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -8,7 +8,7 @@
  * the Free Software Foundation.
  */
 
-#include <linux/input-mt.h>
+#include <linux/input/mt.h>
 #include <linux/slab.h>
 
 #define TRKID_SGN	((TRKID_MAX + 1) >> 1)
diff --git a/drivers/input/input.c b/drivers/input/input.c
index a0691d6..cddadd6 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -14,7 +14,7 @@
 
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/input-mt.h>
+#include <linux/input/mt.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/random.h>
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 67aa7ba..bea8972 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -37,7 +37,7 @@
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/uinput.h>
-#include <linux/input-mt.h>
+#include <linux/input/mt.h>
 #include "../input-compat.h"
 
 static int uinput_dev_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 0104e1a..58256ad 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -14,7 +14,7 @@
 
 #include "wacom_wac.h"
 #include "wacom.h"
-#include <linux/input-mt.h>
+#include <linux/input/mt.h>
 
 static int wacom_penpartner_irq(struct wacom_wac *wacom)
 {
diff --git a/drivers/input/touchscreen/wacom_w8001.c b/drivers/input/touchscreen/wacom_w8001.c
index 361d00a..2a0bec1 100644
--- a/drivers/input/touchscreen/wacom_w8001.c
+++ b/drivers/input/touchscreen/wacom_w8001.c
@@ -15,7 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/input-mt.h>
+#include <linux/input/mt.h>
 #include <linux/serio.h>
 #include <linux/init.h>
 #include <linux/ctype.h>
diff --git a/include/linux/input-mt.h b/include/linux/input/mt.h
similarity index 100%
rename from include/linux/input-mt.h
rename to include/linux/input/mt.h
-- 
1.7.1

