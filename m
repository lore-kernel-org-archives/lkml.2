Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1BCPOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:14:49 -0500
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:52971 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755525Ab1BCPOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:14:47 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-18.arcor-online.net 743A53DC6E5
Subject: [PATCH 9/8] HID: roccat: Renamed header roccat.h -> hid-roccat.h
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1102031116100.2160@pobox.suse.cz>
References: <1296391105.2283.184.camel@neuromancer>
	 <alpine.LNX.2.00.1102031116100.2160@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 16:14:43 +0100
Message-ID: <1296746083.2258.4.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was desired that the header roccat.h should be named hid-roccat.h

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 Documentation/ioctl/ioctl-number.txt |    2 +-
 drivers/hid/hid-roccat-arvo.c        |    2 +-
 drivers/hid/hid-roccat-kone.c        |    2 +-
 drivers/hid/hid-roccat-koneplus.c    |    2 +-
 drivers/hid/hid-roccat-kovaplus.c    |    2 +-
 drivers/hid/hid-roccat-pyra.c        |    2 +-
 drivers/hid/hid-roccat.c             |    2 +-
 include/linux/hid-roccat.h           |   29 +++++++++++++++++++++++++++++
 include/linux/roccat.h               |   29 -----------------------------
 9 files changed, 36 insertions(+), 36 deletions(-)
 create mode 100644 include/linux/hid-roccat.h
 delete mode 100644 include/linux/roccat.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index b0f1fa0..e68543f 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -133,7 +133,7 @@ Code  Seq#(hex)	Include File		Comments
 'H'	C0-DF	net/bluetooth/hidp/hidp.h	conflict!
 'H'	C0-DF	net/bluetooth/cmtp/cmtp.h	conflict!
 'H'	C0-DF	net/bluetooth/bnep/bnep.h	conflict!
-'H'	F1	linux/roccat.h		<mailto:erazor_de@users.sourceforge.net>
+'H'	F1	linux/hid-roccat.h	<mailto:erazor_de@users.sourceforge.net>
 'I'	all	linux/isdn.h		conflict!
 'I'	00-0F	drivers/isdn/divert/isdn_divert.h	conflict!
 'I'	40-4F	linux/mISDNif.h		conflict!
diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
index 75f532f..2307471 100644
--- a/drivers/hid/hid-roccat-arvo.c
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -21,7 +21,7 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/roccat.h>
+#include <linux/hid-roccat.h>
 #include "hid-ids.h"
 #include "hid-roccat-common.h"
 #include "hid-roccat-arvo.h"
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index d749796..a57838d 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -30,7 +30,7 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/roccat.h>
+#include <linux/hid-roccat.h>
 #include "hid-ids.h"
 #include "hid-roccat-common.h"
 #include "hid-roccat-kone.h"
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index ac20107..a8e2117 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -21,7 +21,7 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/roccat.h>
+#include <linux/hid-roccat.h>
 #include "hid-ids.h"
 #include "hid-roccat-common.h"
 #include "hid-roccat-koneplus.h"
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 4eeb62f..984be2f 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -20,7 +20,7 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/roccat.h>
+#include <linux/hid-roccat.h>
 #include "hid-ids.h"
 #include "hid-roccat-common.h"
 #include "hid-roccat-kovaplus.h"
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 02a7243..160f481 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -22,7 +22,7 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/roccat.h>
+#include <linux/hid-roccat.h>
 #include "hid-ids.h"
 #include "hid-roccat-common.h"
 #include "hid-roccat-pyra.h"
diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index bbe294c..5666e75 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -26,7 +26,7 @@
 #include <linux/cdev.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
-#include <linux/roccat.h>
+#include <linux/hid-roccat.h>
 
 #define ROCCAT_FIRST_MINOR 0
 #define ROCCAT_MAX_DEVICES 8
diff --git a/include/linux/hid-roccat.h b/include/linux/hid-roccat.h
new file mode 100644
index 0000000..24e1ca0
--- /dev/null
+++ b/include/linux/hid-roccat.h
@@ -0,0 +1,29 @@
+#ifndef __HID_ROCCAT_H
+#define __HID_ROCCAT_H
+
+/*
+ * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/hid.h>
+#include <linux/types.h>
+
+#define ROCCATIOCGREPSIZE _IOR('H', 0xf1, int)
+
+#ifdef __KERNEL__
+
+int roccat_connect(struct class *klass, struct hid_device *hid,
+		int report_size);
+void roccat_disconnect(int minor);
+int roccat_report_event(int minor, u8 const *data);
+
+#endif
+
+#endif
diff --git a/include/linux/roccat.h b/include/linux/roccat.h
deleted file mode 100644
index 24e1ca0..0000000
--- a/include/linux/roccat.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef __HID_ROCCAT_H
-#define __HID_ROCCAT_H
-
-/*
- * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- */
-
-#include <linux/hid.h>
-#include <linux/types.h>
-
-#define ROCCATIOCGREPSIZE _IOR('H', 0xf1, int)
-
-#ifdef __KERNEL__
-
-int roccat_connect(struct class *klass, struct hid_device *hid,
-		int report_size);
-void roccat_disconnect(int minor);
-int roccat_report_event(int minor, u8 const *data);
-
-#endif
-
-#endif
-- 
1.7.3.4



