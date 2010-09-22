Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0IVFTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:19:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0IVFTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:19:12 -0400
From: cdahlin@redhat.com
To: linux-kernel@vger.kernel.org
Cc: Casey Dahlin <cdahlin@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
        linux-arch@vger.kernel.org
Subject: [PATCH 2/3] Add inotify_add_watch_at to asm-generic/unistd.h
Date: Wed, 22 Sep 2010 01:16:57 -0400
Message-Id: <1285132618-31573-3-git-send-email-cdahlin@redhat.com>
In-Reply-To: <1285132618-31573-1-git-send-email-cdahlin@redhat.com>
References: <1285132618-31573-1-git-send-email-cdahlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Dahlin <cdahlin@redhat.com>

Signed-off-by: Casey Dahlin <cdahlin@redhat.com>
---
 include/asm-generic/unistd.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index b969770..fd7b127 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -646,9 +646,11 @@ __SYSCALL(__NR_prlimit64, sys_prlimit64)
 __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 #define __NR_fanotify_mark 263
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
+#define __NR_inotify_add_watch_at 264
+__SYSCALL(__NR_inotify_add_watch_at, sys_inotify_add_watch)
 
 #undef __NR_syscalls
-#define __NR_syscalls 264
+#define __NR_syscalls 265
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.2.3

