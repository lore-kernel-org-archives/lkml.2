Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0JTRjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:39:25 -0400
Received: from mail.perches.com ([173.55.12.10]:3362 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab0JTRjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:39:24 -0400
Subject: [PATCH] drivers/mtd/devices/phram.c: Use KBUILD_MODNAME
From: Joe Perches <joe@perches.com>
To: Joern Engel <joern@lazybastard.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 10:39:22 -0700
Message-ID: <1287596362.1813.205.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more standard #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
No change in output strings.

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index 1696bbe..5239328 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -15,7 +15,7 @@
  *	phram=swap,64Mi,128Mi phram=test,900Mi,1Mi
  */
 
-#define pr_fmt(fmt) "phram: " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <asm/io.h>
 #include <linux/init.h>


