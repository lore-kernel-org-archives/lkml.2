Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab0LNNdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:33:41 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:45084 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752241Ab0LNNdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:33:40 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+OAzlaOZ2OVyJWPLG9WhUgHP+dcV0aMEJp9sMyG+
	yitatWqma4m2je
From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
To: kernel-janitors@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH] checkpatch.pl: fix 2 of 2 errors in ./kernek/panic.c
Date: Tue, 14 Dec 2010 14:33:35 +0100
Message-Id: <1292333615-17860-1-git-send-email-toralf.foerster@gmx.de>
X-Mailer: git-send-email 1.7.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
---
 kernel/panic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 4c13b1a..13623e4 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -56,7 +56,7 @@ EXPORT_SYMBOL(panic_blink);
  *
  *	This function never returns.
  */
-NORET_TYPE void panic(const char * fmt, ...)
+NORET_TYPE void panic(const char *fmt, ...)
 {
 	static char buf[1024];
 	va_list args;
@@ -75,7 +75,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+	printk(KERN_EMERG "Kernel panic - not syncing: %s\n", buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	dump_stack();
 #endif
-- 
1.7.3.3

