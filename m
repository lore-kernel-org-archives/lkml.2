Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422674Ab1FQT56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:57:58 -0400
Received: from outmail010.snc4.facebook.com ([66.220.144.142]:34840 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933042Ab1FQT5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:57:46 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] atomic: Update comments in atomic.h
Date: Fri, 17 Jun 2011 12:57:10 -0700
Message-Id: <1308340630-16008-4-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1308340630-16008-1-git-send-email-asharma@fb.com>
References: <1308340630-16008-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This clarifies the differences between <linux/atomic.h> and
<asm-generic/atomic.h>

Signed-off-by: Arun Sharma <asharma@fb.com>
Suggested-by: Mike Frysinger <vapier.adi@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/asm-generic/atomic.h |    4 +++-
 include/linux/atomic.h       |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index a8fad94..90e23ea 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -1,5 +1,7 @@
 /*
- * Generic C implementation of atomic counter operations
+ * Generic C implementation of atomic counter operations. Usable on
+ * UP systems only. Do not include in machine independent code.
+ *
  * Originally implemented for MN10300.
  *
  * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index f2e6529..9f3a4ea 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -1,3 +1,4 @@
+/* Atomic operations usable in machine independent code */
 #ifndef _LINUX_ATOMIC_H
 #define _LINUX_ATOMIC_H
 #include <asm/atomic.h>
-- 
1.7.4

