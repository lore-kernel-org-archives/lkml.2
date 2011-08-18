Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1HRTIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:08:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47511 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab1HRTIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:08:10 -0400
Date: Thu, 18 Aug 2011 20:08:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 55/91] um: kill shared/mem_kern.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7wn-0007rS-OT@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... nothing declared there exists

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/drivers/ubd_kern.c        |    1 -
 arch/um/include/shared/mem_kern.h |   20 --------------------
 2 files changed, 0 insertions(+), 21 deletions(-)
 delete mode 100644 arch/um/include/shared/mem_kern.h

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 0136be1..b3c8545 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -53,7 +53,6 @@
 #include "ubd_user.h"
 #include "os.h"
 #include "mem.h"
-#include "mem_kern.h"
 #include "cow.h"
 
 enum ubd_req { UBD_READ, UBD_WRITE };
diff --git a/arch/um/include/shared/mem_kern.h b/arch/um/include/shared/mem_kern.h
deleted file mode 100644
index 69be0fd..0000000
--- a/arch/um/include/shared/mem_kern.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Copyright (C) 2003 Jeff Dike (jdike@addtoit.com)
- * Licensed under the GPL
- */
-
-#ifndef __MEM_KERN_H__
-#define __MEM_KERN_H__
-
-#include "linux/list.h"
-#include "linux/types.h"
-
-struct remapper {
-	struct list_head list;
-	int (*proc)(int, unsigned long, int, __u64);
-};
-
-extern void register_remapper(struct remapper *info);
-
-#endif
-
-- 
1.7.2.5


