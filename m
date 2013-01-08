Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3AHVhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:37:14 -0500
Received: from www84.your-server.de ([213.133.104.84]:50529 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3AHVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:37:12 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: stefani@seibold.net
Subject: [PATCH 1/2] move kfifo.c from kernel/ to lib/
Date: Tue,  8 Jan 2013 22:36:20 +0100
Message-Id: <1357680984-23007-2-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357680984-23007-1-git-send-email-stefani@seibold.net>
References: <1357680984-23007-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch move the kfifo.c file from kernel/ to lib/

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 kernel/Makefile         | 2 +-
 lib/Makefile            | 2 +-
 {kernel => lib}/kfifo.c | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {kernel => lib}/kfifo.c (100%)

diff --git a/kernel/Makefile b/kernel/Makefile
index 6c072b6..619c79b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o panic.o printk.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
-	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
+	    kthread.o wait.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o \
 	    async.o range.o groups.o lglock.o smpboot.o
diff --git a/lib/Makefile b/lib/Makefile
index 02ed6c0..d7946ff 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -23,7 +23,7 @@ lib-y	+= kobject.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
-	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o
+	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
diff --git a/kernel/kfifo.c b/lib/kfifo.c
similarity index 100%
rename from kernel/kfifo.c
rename to lib/kfifo.c
-- 
1.8.0.2

