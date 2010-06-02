Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab0FBT6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:58:33 -0400
Received: from mail.perches.com ([173.55.12.10]:2564 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933022Ab0FBT6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:58:32 -0400
Subject: [PATCH] kernel.h: Remove unused NIPQUAD and NIPQUAD_FMT
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 12:58:30 -0700
Message-ID: <1275508710.23599.31.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more uses of NIPQUAD or NIPQUAD_FMT.
Remove the definitions.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..81892d2 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -609,17 +609,6 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #endif /* CONFIG_TRACING */
 
 /*
- *      Display an IP address in readable format.
- */
-
-#define NIPQUAD(addr) \
-	((unsigned char *)&addr)[0], \
-	((unsigned char *)&addr)[1], \
-	((unsigned char *)&addr)[2], \
-	((unsigned char *)&addr)[3]
-#define NIPQUAD_FMT "%u.%u.%u.%u"
-
-/*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
  * "unnecessary" pointer comparison.


