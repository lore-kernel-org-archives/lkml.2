Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2IYMyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:54:22 -0400
Received: from mail.ispras.ru ([83.149.199.43]:59870 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab2IYMyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:54:21 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list), ldv-project@linuxtesting.org
Subject: [PATCH] staging/gdm72xx: coding style fixes gdm_qos.c
Date: Tue, 25 Sep 2012 16:53:52 +0400
Message-Id: <1348577632-25462-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl warnings:
WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...
WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/gdm72xx/gdm_qos.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 80bde05..ed60138 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -25,12 +25,12 @@
 #define B2H(x)		__be16_to_cpu(x)
 
 #undef dprintk
-#define dprintk(fmt, args ...) printk(KERN_DEBUG "[QoS] " fmt, ## args)
+#define dprintk(fmt, args ...) pr_debug("[QoS] " fmt, ## args)
 #undef wprintk
 #define wprintk(fmt, args ...) \
-	printk(KERN_WARNING "[QoS WARNING] " fmt, ## args)
+	pr_warn("[QoS WARNING] " fmt, ## args)
 #undef eprintk
-#define eprintk(fmt, args ...) printk(KERN_ERR "[QoS ERROR] " fmt, ## args)
+#define eprintk(fmt, args ...) pr_err("[QoS ERROR] " fmt, ## args)
 
 
 #define MAX_FREE_LIST_CNT		32
-- 
1.7.9.5

