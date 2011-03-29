Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab1C2WXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:23:51 -0400
Received: from mail.perches.com ([173.55.12.10]:4383 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab1C2WWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:38 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/23] tc1100-wmi: Add pr_fmt, use pr_<level>
Date: Tue, 29 Mar 2011 15:21:49 -0700
Message-Id: <8de8539c2492a6f4837de50f482258ad709af1e7.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more normal logging styles.
Removed now unused local logging #defines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/tc1100-wmi.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/tc1100-wmi.c b/drivers/platform/x86/tc1100-wmi.c
index 865ef78..e24f5ae 100644
--- a/drivers/platform/x86/tc1100-wmi.c
+++ b/drivers/platform/x86/tc1100-wmi.c
@@ -25,6 +25,8 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -40,9 +42,6 @@
 #define TC1100_INSTANCE_WIRELESS		1
 #define TC1100_INSTANCE_JOGDIAL		2
 
-#define TC1100_LOGPREFIX "tc1100-wmi: "
-#define TC1100_INFO KERN_INFO TC1100_LOGPREFIX
-
 MODULE_AUTHOR("Jamey Hicks, Carlos Corbacho");
 MODULE_DESCRIPTION("HP Compaq TC1100 Tablet WMI Extras");
 MODULE_LICENSE("GPL");
@@ -264,7 +263,7 @@ static int __init tc1100_init(void)
 	if (error)
 		goto err_device_del;
 
-	printk(TC1100_INFO "HP Compaq TC1100 Tablet WMI Extras loaded\n");
+	pr_info("HP Compaq TC1100 Tablet WMI Extras loaded\n");
 	return 0;
 
  err_device_del:
-- 
1.7.4.2.g597a6.dirty

