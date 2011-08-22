Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1HVSuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:50:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46025 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1HVSuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:50:22 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: ascardo@holoscopio.com, dan.magenheimer@oracle.com,
        sjenning@linux.vnet.ibm.com, rdunlap@xenotime.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: zcache: fix typos
Date: Mon, 22 Aug 2011 13:50:08 -0500
Message-Id: <1314039008-8845-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes two typos in zcache-main.c

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 855a5bb..82054c9 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -651,7 +651,7 @@ static unsigned int zv_max_zsize = (PAGE_SIZE / 8) * 7;
 /*
  * byte count defining poor *mean* compression; pages with greater zsize
  * will be rejected until sufficient better-compressed pages are accepted
- * driving the man below this threshold
+ * driving the mean below this threshold
  */
 static unsigned int zv_max_mean_zsize = (PAGE_SIZE / 8) * 5;
 
@@ -1993,7 +1993,7 @@ static int __init zcache_init(void)
 		pr_info("zcache: frontswap enabled using kernel "
 			"transcendent memory and xvmalloc\n");
 		if (old_ops.init != NULL)
-			pr_warning("ktmem: frontswap_ops overridden");
+			pr_warning("zcache: frontswap_ops overridden");
 	}
 #endif
 out:
-- 
1.7.4.1

