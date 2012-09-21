Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab2IUQA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:00:29 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37452 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab2IUQA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:00:26 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/2] add finit_module syscall to asm-generic
Date: Fri, 21 Sep 2012 09:00:06 -0700
Message-Id: <1348243206-6893-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the finit_module syscall to the generic syscall list.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/unistd.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 991ef01..671d746 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -691,9 +691,11 @@ __SC_COMP(__NR_process_vm_readv, sys_process_vm_readv, \
 #define __NR_process_vm_writev 271
 __SC_COMP(__NR_process_vm_writev, sys_process_vm_writev, \
           compat_sys_process_vm_writev)
+#define __NR_finit_module 272
+__SYSCALL(__NR_finit_module, sys_finit_module)
 
 #undef __NR_syscalls
-#define __NR_syscalls 272
+#define __NR_syscalls 273
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.0.4

