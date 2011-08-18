Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1HRTEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:04:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44311 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab1HRTEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:04:50 -0400
Date: Thu, 18 Aug 2011 20:04:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 35/91] um: take system.h out of shared/sysdep
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7tZ-0007gB-Fi@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/{system.h => system-um.h}   |    2 --
 arch/um/sys-x86/{shared/sysdep => asm}/system.h |    1 +
 2 files changed, 1 insertions(+), 2 deletions(-)
 rename arch/um/include/asm/{system.h => system-um.h} (96%)
 rename arch/um/sys-x86/{shared/sysdep => asm}/system.h (99%)

diff --git a/arch/um/include/asm/system.h b/arch/um/include/asm/system-um.h
similarity index 96%
rename from arch/um/include/asm/system.h
rename to arch/um/include/asm/system-um.h
index 68a90ec..0eec245 100644
--- a/arch/um/include/asm/system.h
+++ b/arch/um/include/asm/system-um.h
@@ -1,8 +1,6 @@
 #ifndef __UM_SYSTEM_GENERIC_H
 #define __UM_SYSTEM_GENERIC_H
 
-#include "sysdep/system.h"
-
 extern int get_signals(void);
 extern int set_signals(int enable);
 extern void block_signals(void);
diff --git a/arch/um/sys-x86/shared/sysdep/system.h b/arch/um/sys-x86/asm/system.h
similarity index 99%
rename from arch/um/sys-x86/shared/sysdep/system.h
rename to arch/um/sys-x86/asm/system.h
index d1b93c4..a89113b 100644
--- a/arch/um/sys-x86/shared/sysdep/system.h
+++ b/arch/um/sys-x86/asm/system.h
@@ -6,6 +6,7 @@
 #include <asm/cpufeature.h>
 #include <asm/cmpxchg.h>
 #include <asm/nops.h>
+#include <asm/system-um.h>
 
 #include <linux/kernel.h>
 #include <linux/irqflags.h>
-- 
1.7.2.5


