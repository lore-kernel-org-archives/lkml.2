Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0HWCmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 22:42:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34444 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0HWCmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 22:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ufFlQXAH8rSYxS/43pdT2gZavfFlX5hen0gBpAaizM+9g7n2X/+9kwXNW90qFZa8if
         2aDqMHzwgvxBReXyJ8A99l7NMc/hVjw1pCpelGIT9uGx9JpECgyyDrgJ9BK1eMzcYYGZ
         Mdx78ZB9LN8TgYB3P48BJ8jVJDrOc5leOxd6g=
From: Changli Gao <xiaosuo@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] net: rds: remove duplication type definitions
Date: Mon, 23 Aug 2010 10:41:59 +0800
Message-Id: <1282531319-13083-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__be* are defined in linux/types.h now, and in fact, rds.h isn't exported
to user space even.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 include/linux/rds.h |    9 ---------
 1 file changed, 9 deletions(-)
diff --git a/include/linux/rds.h b/include/linux/rds.h
index 24bce3d..7f3971d 100644
--- a/include/linux/rds.h
+++ b/include/linux/rds.h
@@ -36,15 +36,6 @@
 
 #include <linux/types.h>
 
-/* These sparse annotated types shouldn't be in any user
- * visible header file. We should clean this up rather
- * than kludging around them. */
-#ifndef __KERNEL__
-#define __be16	u_int16_t
-#define __be32	u_int32_t
-#define __be64	u_int64_t
-#endif
-
 #define RDS_IB_ABI_VERSION		0x301
 
 /*
