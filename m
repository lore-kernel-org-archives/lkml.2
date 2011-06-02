Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1FBS03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:26:29 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:56616 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1FBS02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:26:28 -0400
Message-Id: <201106021826.p52IQQSG032352@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 2 Jun 2011 14:21:45 -0400
Subject: [PATCH] asm-generic/unistd.h: support sendmmsg syscall
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 Jun 2011 18:26:27.0469 (UTC) FILETIME=[96029BD0:01CC2152]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
I'll ask Linus to pull this for 3.0.

 include/asm-generic/unistd.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index ae90e0f..4f76959 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -683,9 +683,11 @@ __SC_COMP(__NR_clock_adjtime, sys_clock_adjtime, compat_sys_clock_adjtime)
 __SYSCALL(__NR_syncfs, sys_syncfs)
 #define __NR_setns 268
 __SYSCALL(__NR_setns, sys_setns)
+#define __NR_sendmmsg 269
+__SC_COMP(__NR_sendmmsg, sys_sendmmsg, compat_sys_sendmmsg)
 
 #undef __NR_syscalls
-#define __NR_syscalls 269
+#define __NR_syscalls 270
 
 /*
  * All syscalls below here should go away really,
-- 
1.6.5.2

