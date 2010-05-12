Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0ELPnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:43:40 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:41154 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754123Ab0ELPni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:43:38 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 7D990107C4A
Subject: [PATCH 1/5] HID: Removing/Renaming preprocessor macros for Roccat
 Kone
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jerome Vidal <jerom3@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 17:43:34 +0200
Message-ID: <1273679014.2927.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a50a004999d4bd2b9ae08f1298b1fc89ce9e1e12 Mon Sep 17 00:00:00 2001
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Date: Sat, 8 May 2010 16:34:05 +0200
Subject: [PATCH 1/5] HID: Removing/Renaming preprocessor macros for Roccat Kone

Removed useless preprocessor macros and renamed remaining one to be
more qualified.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |    8 ++++----
 drivers/hid/hid-roccat-kone.h |    5 +----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 7b11784..d23d309 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -630,7 +630,7 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
 static ssize_t kone_sysfs_show_driver_version(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, DRIVER_VERSION "\n");
+	return snprintf(buf, PAGE_SIZE, ROCCAT_KONE_DRIVER_VERSION "\n");
 }
 
 /*
@@ -1002,6 +1002,6 @@ static void kone_exit(void)
 module_init(kone_init);
 module_exit(kone_exit);
 
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE(DRIVER_LICENSE);
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat Kone driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
index ee6898c..99290ad 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -14,10 +14,7 @@
 
 #include <linux/types.h>
 
-#define DRIVER_VERSION "v0.3.0"
-#define DRIVER_AUTHOR "Stefan Achatz"
-#define DRIVER_DESC "USB Roccat Kone driver"
-#define DRIVER_LICENSE "GPL v2"
+#define ROCCAT_KONE_DRIVER_VERSION "v0.3.1"
 
 #pragma pack(push)
 #pragma pack(1)
-- 
1.6.6.1



