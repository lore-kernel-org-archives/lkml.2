Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2ITUHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 16:07:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57669 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab2ITUHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 16:07:16 -0400
Date: Thu, 20 Sep 2012 13:07:02 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] module: add finit_module syscall to asm-generic
Message-ID: <20120920200702.GA18807@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the finit_module syscall to the generic syscall list.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This depends on the finit_module patchset in Rusty's tree, based on
https://lkml.org/lkml/2012/9/7/559
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


-- 
Kees Cook
Chrome OS Security
