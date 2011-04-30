Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab1D3UqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:46:16 -0400
Received: from que31.charter.net ([209.225.8.23]:40275 "EHLO que31.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab1D3UqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:46:15 -0400
X-Greylist: delayed 1236 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Apr 2011 16:46:14 EDT
X-Authority-Analysis: v=1.1 cv=zUqQ2eogioz8lh+3uqjRe4Y1MWSUJU+U3b3PFzAwX18=
 c=1 sm=1 a=Dk4MbfjhGekA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=hN84ZiHtMxD_Eii78JsA:9 a=wlkIml4Ky05QzSok20cA:7 a=5N0Ir_AMj3kIMf9q:21
 a=74aD_cFv8ZgiZS4x:21 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <gregory.dietsche@cuw.edu>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com, jarod@redhat.com, u.kleine-koenig@pengutronix.de,
        arnd@arndb.de, Greg Dietsche <gregory.dietsche@cuw.edu>
Subject: [PATCH] lirc: fixed coding style
Date: Sat, 30 Apr 2011 15:03:20 -0500
Message-Id: <1304193800-4511-1-git-send-email-gregory.dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a few minor coding style issues reported by checkpatch.pl

Signed-off-by: Greg Dietsche <gregory.dietsche@cuw.edu>
---
 drivers/staging/lirc/lirc_parallel.c |   27 ++++++++++++++-------------
 drivers/staging/lirc/lirc_sir.c      |   30 +++++++++++++++---------------
 2 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/lirc/lirc_parallel.c b/drivers/staging/lirc/lirc_parallel.c
index 832522c..50724c4 100644
--- a/drivers/staging/lirc/lirc_parallel.c
+++ b/drivers/staging/lirc/lirc_parallel.c
@@ -568,17 +568,17 @@ static void set_use_dec(void *data)
 }
 
 static struct lirc_driver driver = {
-       .name		= LIRC_DRIVER_NAME,
-       .minor		= -1,
-       .code_length	= 1,
-       .sample_rate	= 0,
-       .data		= NULL,
-       .add_to_buf	= NULL,
-       .set_use_inc	= set_use_inc,
-       .set_use_dec	= set_use_dec,
-       .fops		= &lirc_fops,
-       .dev		= NULL,
-       .owner		= THIS_MODULE,
+	.name		= LIRC_DRIVER_NAME,
+	.minor		= -1,
+	.code_length	= 1,
+	.sample_rate	= 0,
+	.data		= NULL,
+	.add_to_buf	= NULL,
+	.set_use_inc	= set_use_inc,
+	.set_use_dec	= set_use_dec,
+	.fops		= &lirc_fops,
+	.dev		= NULL,
+	.owner		= THIS_MODULE,
 };
 
 static struct platform_device *lirc_parallel_dev;
@@ -594,7 +594,7 @@ static int __devexit lirc_parallel_remove(struct platform_device *dev)
 }
 
 static int lirc_parallel_suspend(struct platform_device *dev,
-                                 pm_message_t state)
+					pm_message_t state)
 {
 	return 0;
 }
@@ -647,7 +647,8 @@ static int __init lirc_parallel_init(void)
 
 	result = platform_driver_register(&lirc_parallel_driver);
 	if (result) {
-		printk("platform_driver_register returned %d\n", result);
+		printk(KERN_NOTICE "platform_driver_register"
+					" returned %d\n", result);
 		return result;
 	}
 
diff --git a/drivers/staging/lirc/lirc_sir.c b/drivers/staging/lirc/lirc_sir.c
index 76be7b8..a7b46f2 100644
--- a/drivers/staging/lirc/lirc_sir.c
+++ b/drivers/staging/lirc/lirc_sir.c
@@ -143,9 +143,9 @@ static unsigned int duty_cycle = 50;   /* duty cycle of 50% */
 #endif
 #ifndef LIRC_PORT
 /* for external dongles, default to com1 */
-#if defined(LIRC_SIR_ACTISYS_ACT200L) || \
-    defined(LIRC_SIR_ACTISYS_ACT220L) || \
-    defined(LIRC_SIR_TEKRAM)
+#if defined(LIRC_SIR_ACTISYS_ACT200L)         || \
+	    defined(LIRC_SIR_ACTISYS_ACT220L) || \
+	    defined(LIRC_SIR_TEKRAM)
 #define LIRC_PORT 0x3f8
 #else
 /* onboard sir ports are typically com3 */
@@ -467,7 +467,7 @@ static const struct file_operations lirc_fops = {
 
 static int set_use_inc(void *data)
 {
-       return 0;
+	return 0;
 }
 
 static void set_use_dec(void *data)
@@ -475,17 +475,17 @@ static void set_use_dec(void *data)
 }
 
 static struct lirc_driver driver = {
-       .name		= LIRC_DRIVER_NAME,
-       .minor		= -1,
-       .code_length	= 1,
-       .sample_rate	= 0,
-       .data		= NULL,
-       .add_to_buf	= NULL,
-       .set_use_inc	= set_use_inc,
-       .set_use_dec	= set_use_dec,
-       .fops		= &lirc_fops,
-       .dev		= NULL,
-       .owner		= THIS_MODULE,
+	.name		= LIRC_DRIVER_NAME,
+	.minor		= -1,
+	.code_length	= 1,
+	.sample_rate	= 0,
+	.data		= NULL,
+	.add_to_buf	= NULL,
+	.set_use_inc	= set_use_inc,
+	.set_use_dec	= set_use_dec,
+	.fops		= &lirc_fops,
+	.dev		= NULL,
+	.owner		= THIS_MODULE,
 };
 
 
-- 
1.7.2.5

