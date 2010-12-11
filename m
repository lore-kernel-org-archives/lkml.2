Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0LLKpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 05:45:34 -0500
Received: from mail-iw0-f170.google.com ([209.85.214.170]:46147 "EHLO
	mail-iw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0LLKpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 05:45:33 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 05:45:33 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WO7NZqw87VvwcEOJa7gCxDCMFhKcS7cGuJzWjsMBHRVltgvkGBYn4jvzxgNOddB74X
         9xZF4zsl7l+8PqD85gcFu7bGMlnv6bDYQNrMQUgEWpT9WY3IQd4OpNMpWI7zS7bJ9Khi
         UMpPIcqaapgNRX8ftcEoWGG75K8yM0nBamXSQ=
From: bookjovi@gmail.com
To: akpm@linux-foundation.org, hidave.darkstar@gmail.com, davem@davemloft.net,
        mingo@elte.hu, eparis@redhat.com, linux-kernel@vger.kernel.org
Cc: Jovi Zhang <bookjovi@gmail.com>
Subject: [PATCH 1/2] sysctl: fix error config typo
Date: Fri, 10 Dec 2010 22:03:44 -0500
Message-Id: <1292036624-3019-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix error config typo

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

 kernel/sysctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 5abfa15..6f3b6f4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2900,7 +2900,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 	}
 }
 
-#else /* CONFIG_PROC_FS */
+#else /* CONFIG_PROC_SYSCTL */
 
 int proc_dostring(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -2952,7 +2952,7 @@ int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 }
 
 
-#endif /* CONFIG_PROC_FS */
+#endif /* CONFIG_PROC_SYSCTL */
 
 /*
  * No sense putting this after each symbol definition, twice,
