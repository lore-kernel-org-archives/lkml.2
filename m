Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab0HKPLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 11:11:17 -0400
Received: from king.tilera.com ([72.1.168.226]:50770 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab0HKPLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 11:11:16 -0400
Message-Id: <201008111511.o7BFBFGd005535@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 11 Aug 2010 11:07:24 -0400
Subject: [PATCH] Add fanotify syscalls to <asm-generic/unistd.h>.
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 11 Aug 2010 15:11:15.0501 (UTC) FILETIME=[7145DDD0:01CB3967]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 include/asm-generic/unistd.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index e189809..b969770 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -642,9 +642,13 @@ __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 __SYSCALL(__NR_wait4, sys_wait4)
 #define __NR_prlimit64 261
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_fanotify_init 262
+__SYSCALL(__NR_fanotify_init, sys_fanotify_init)
+#define __NR_fanotify_mark 263
+__SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 
 #undef __NR_syscalls
-#define __NR_syscalls 262
+#define __NR_syscalls 264
 
 /*
  * All syscalls below here should go away really,
-- 
1.6.5.2

