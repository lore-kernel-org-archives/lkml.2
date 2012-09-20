Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab2ITWQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:16:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52233 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab2ITWPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:15:45 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 4/4] add finit_module syscall to asm-generic
Date: Thu, 20 Sep 2012 15:15:00 -0700
Message-Id: <1348179300-11653-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1348179300-11653-1-git-send-email-keescook@chromium.org>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the finit_module syscall to the generic syscall list.

Signed-off-by: Kees Cook <keescook@chromium.org>
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

