Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1DMXlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:41:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42638 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372Ab1DMXlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:41:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic/system.h: drop useless __KERNEL__
Date: Wed, 13 Apr 2011 19:41:50 -0400
Message-Id: <1302738110-22344-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header isn't exported to user-space, and even if it was, the
__KERNEL__ check covers the entire file, so we'd get a useless stub
in the first place.  So punt it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/system.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/system.h b/include/asm-generic/system.h
index 4b0b9cb..215efa7 100644
--- a/include/asm-generic/system.h
+++ b/include/asm-generic/system.h
@@ -14,7 +14,6 @@
 #ifndef __ASM_GENERIC_SYSTEM_H
 #define __ASM_GENERIC_SYSTEM_H
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
@@ -139,5 +138,4 @@ unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
 
 #endif /* !__ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_SYSTEM_H */
-- 
1.7.5.rc1

