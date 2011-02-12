Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab1BLEOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 23:14:10 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39095 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab1BLEOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 23:14:08 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] zcache: Fix build error when sysfs is not defined
Date: Fri, 11 Feb 2011 23:14:39 -0500
Message-Id: <1297484079-12562-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zcache/zcache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/zcache.c b/drivers/staging/zcache/zcache.c
index 61be849..8cd3fd8 100644
--- a/drivers/staging/zcache/zcache.c
+++ b/drivers/staging/zcache/zcache.c
@@ -1590,9 +1590,9 @@ __setup("nofrontswap", no_frontswap);
 
 static int __init zcache_init(void)
 {
-#ifdef CONFIG_SYSFS
 	int ret = 0;
 
+#ifdef CONFIG_SYSFS
 	ret = sysfs_create_group(mm_kobj, &zcache_attr_group);
 	if (ret) {
 		pr_err("zcache: can't create sysfs\n");
-- 
1.7.3.5

