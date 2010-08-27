Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0H0LEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:04:42 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59566 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0H0LEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:04:36 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V19 12/15] unistd.h: Add new syscalls numbers to asm-generic
Date: Fri, 27 Aug 2010 16:32:59 +0530
Message-Id: <1282906982-26918-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/asm-generic/unistd.h |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index b969770..3efb463 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -646,9 +646,32 @@ __SYSCALL(__NR_prlimit64, sys_prlimit64)
 __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 #define __NR_fanotify_mark 263
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
+#define __NR_name_to_handle_at		264
+__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
+#define __NR_open_by_handle_at		265
+__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
+#define __NR_readlink_by_handle		266
+__SYSCALL(__NR_readlink_by_handle, sys_handle_readlink)
+#define __NR_stat64_by_handle		267
+__SYSCALL(__NR_stat64_by_handle, sys_handle_stat64)
+#define __NR_link_by_handle		268
+__SYSCALL(__NR_link_by_handle, sys_handle_link)
+#define __NR_chown_by_handle		269
+__SYSCALL(__NR_chown_by_handle, sys_handle_chown)
+#define __NR_setxattr_by_handle		270
+__SYSCALL(__NR_setxattr_by_handle, sys_handle_setxattr)
+#define __NR_getxattr_by_handle		271
+__SYSCALL(__NR_getxattr_by_handle, sys_handle_getxattr)
+#define __NR_listxattr_by_handle	272
+__SYSCALL(__NR_listxattr_by_handle, sys_handle_listxattr)
+#define __NR_removexattr_by_handle	273
+__SYSCALL(__NR_removexattr_by_handle, sys_handle_removexattr)
+#define __NR_utimes_by_handle		274
+__SYSCALL(__NR_utimes_by_handle, sys_handle_utimes)
+
 
 #undef __NR_syscalls
-#define __NR_syscalls 264
+#define __NR_syscalls 275
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.0.4

