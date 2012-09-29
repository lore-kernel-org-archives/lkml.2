Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2I2RHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 13:07:49 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:49033 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab2I2RHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 13:07:46 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        x86@kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/4] um: Remove obsolete UM_ prefixed printk() level specifiers
Date: Sat, 29 Sep 2012 19:07:40 +0200
Message-Id: <1348938460-20919-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1348938460-20919-1-git-send-email-geert@linux-m68k.org>
References: <1348938460-20919-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All user parts of UML are using the non-prefixed printk() level specifiers

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/um/include/shared/user.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/um/include/shared/user.h b/arch/um/include/shared/user.h
index cef0685..4fa82c0 100644
--- a/arch/um/include/shared/user.h
+++ b/arch/um/include/shared/user.h
@@ -26,17 +26,6 @@
 extern void panic(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
 
-/* Requires preincluding include/linux/kern_levels.h */
-#define UM_KERN_EMERG	KERN_EMERG
-#define UM_KERN_ALERT	KERN_ALERT
-#define UM_KERN_CRIT	KERN_CRIT
-#define UM_KERN_ERR	KERN_ERR
-#define UM_KERN_WARNING	KERN_WARNING
-#define UM_KERN_NOTICE	KERN_NOTICE
-#define UM_KERN_INFO	KERN_INFO
-#define UM_KERN_DEBUG	KERN_DEBUG
-#define UM_KERN_CONT	KERN_CONT
-
 #ifdef UML_CONFIG_PRINTK
 extern int printk(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
-- 
1.7.0.4

