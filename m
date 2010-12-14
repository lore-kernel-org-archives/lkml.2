Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab0LNMzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:55:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:57690 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755523Ab0LNMzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:55:53 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+awUZMrcma/erpbEYllpO9yLLVofr8h64JGgGJXo
	lLSy0O/kOeeh81
From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH] checkpatch.pl: fix 2 of 2 errors in ./kernel/user.c
Date: Tue, 14 Dec 2010 13:55:48 +0100
Message-Id: <1292331348-27268-1-git-send-email-toralf.foerster@gmx.de>
X-Mailer: git-send-email 1.7.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
---
 kernel/user.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 2c7d8d5..6db8ed9 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -5,7 +5,7 @@
  *
  * We have a per-user structure to keep track of how many
  * processes, files etc the user has claimed, in order to be
- * able to have per-user limits for system resources. 
+ * able to have per-user limits for system resources.
  */
 
 #include <linux/init.h>
@@ -181,7 +181,7 @@ static int __init uid_cache_init(void)
 	uid_cachep = kmem_cache_create("uid_cache", sizeof(struct user_struct),
 			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 
-	for(n = 0; n < UIDHASH_SZ; ++n)
+	for (n = 0; n < UIDHASH_SZ; ++n)
 		INIT_HLIST_HEAD(init_user_ns.uidhash_table + n);
 
 	/* Insert the root user immediately (init already runs as root) */
-- 
1.7.3.3

