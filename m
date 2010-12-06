Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab0LFFo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 00:44:27 -0500
Received: from mail.perches.com ([173.55.12.10]:2273 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0LFFoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 00:44:25 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Matt Mackall <mpm@selenic.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-embedded@vger.kernel.org
Subject: [PATCH 2/7] include/linux/printk.h: Use space after #define
Date: Sun,  5 Dec 2010 21:44:16 -0800
Message-Id: <c35312ec9dc69053ceee9a3bf6200867e9c526d8.1291611191.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1291611190.git.joe@perches.com>
References: <cover.1291611190.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/printk.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 0b4513b..b6218d3 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -4,14 +4,14 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
-#define	KERN_EMERG	"<0>"	/* system is unusable			*/
-#define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
-#define	KERN_CRIT	"<2>"	/* critical conditions			*/
-#define	KERN_ERR	"<3>"	/* error conditions			*/
-#define	KERN_WARNING	"<4>"	/* warning conditions			*/
-#define	KERN_NOTICE	"<5>"	/* normal but significant condition	*/
-#define	KERN_INFO	"<6>"	/* informational			*/
-#define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
+#define KERN_EMERG	"<0>"	/* system is unusable			*/
+#define KERN_ALERT	"<1>"	/* action must be taken immediately	*/
+#define KERN_CRIT	"<2>"	/* critical conditions			*/
+#define KERN_ERR	"<3>"	/* error conditions			*/
+#define KERN_WARNING	"<4>"	/* warning conditions			*/
+#define KERN_NOTICE	"<5>"	/* normal but significant condition	*/
+#define KERN_INFO	"<6>"	/* informational			*/
+#define KERN_DEBUG	"<7>"	/* debug-level messages			*/
 
 /* Use the default kernel loglevel */
 #define KERN_DEFAULT	"<d>"
@@ -20,7 +20,7 @@ extern const char linux_proc_banner[];
  * line that had no enclosing \n). Only to be used by core/arch code
  * during early bootup (a continued line is not SMP-safe otherwise).
  */
-#define	KERN_CONT	"<c>"
+#define KERN_CONT	"<c>"
 
 extern int console_printk[];
 
-- 
1.7.3.2.245.g03276.dirty

