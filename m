Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0EEGDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 02:03:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab0EEGDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 02:03:08 -0400
Date: Wed, 5 May 2010 02:02:52 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20100505060651.4666.17804.sendpatchset@localhost.localdomain>
Subject: [Patch] proc: remove obsolete comments
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick test shows these comments are obsolete, so just remove them.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 43c1274..2791907 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -343,21 +343,6 @@ static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */
 /*
  * Return an inode number between PROC_DYNAMIC_FIRST and
  * 0xffffffff, or zero on failure.
- *
- * Current inode allocations in the proc-fs (hex-numbers):
- *
- * 00000000		reserved
- * 00000001-00000fff	static entries	(goners)
- *      001		root-ino
- *
- * 00001000-00001fff	unused
- * 0001xxxx-7fffxxxx	pid-dir entries for pid 1-7fff
- * 80000000-efffffff	unused
- * f0000000-ffffffff	dynamic entries
- *
- * Goal:
- *	Once we split the thing into several virtual filesystems,
- *	we will get rid of magical ranges (and this comment, BTW).
  */
 static unsigned int get_inode_number(void)
 {
