Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2KHNw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:52:59 -0500
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:56787 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751505Ab2KHNw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:52:58 -0500
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/5] kernel: Remove reference to feature-removal-schedule.txt.
Date: Thu,  8 Nov 2012 21:50:32 +0800
Message-Id: <1352382635-2773-2-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352382635-2773-1-git-send-email-tm@tao.ma>
References: <1352382402-2706-1-git-send-email-tm@tao.ma>
 <1352382635-2773-1-git-send-email-tm@tao.ma>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 122.224.222.226 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
but there is still some reference to this file. So remove them.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 kernel/cgroup.c |    1 -
 kernel/module.c |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f24f724..46cfd4c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1381,7 +1381,6 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	if (ret)
 		goto out_unlock;
 
-	/* See feature-removal-schedule.txt */
 	if (opts.subsys_mask != root->actual_subsys_mask || opts.release_agent)
 		pr_warning("cgroup: option changes via remount are deprecated (pid=%d comm=%s)\n",
 			   task_tgid_nr(current), current->comm);
diff --git a/kernel/module.c b/kernel/module.c
index 6085f5e..b4e3f0c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -372,9 +372,6 @@ static bool check_symbol(const struct symsearch *syms,
 			printk(KERN_WARNING "Symbol %s is being used "
 			       "by a non-GPL module, which will not "
 			       "be allowed in the future\n", fsa->name);
-			printk(KERN_WARNING "Please see the file "
-			       "Documentation/feature-removal-schedule.txt "
-			       "in the kernel source tree for more details.\n");
 		}
 	}
 
-- 
1.7.0.4

