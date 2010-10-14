Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0JNKFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:05:35 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56150 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab0JNKFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:05:34 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Oct 2010 06:05:34 EDT
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH] dynamic_debug.h: Fix dynamic_dev_dbg() macro if CONFIG_DYNAMIC_DEBUG not set
Date: Thu, 14 Oct 2010 11:58:20 +0200
Message-Id: <1287050300-3296-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 include/linux/dynamic_debug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 52c0da4..81bc20e 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -80,7 +80,7 @@ static inline int ddebug_remove_module(const char *mod)
 
 #define dynamic_pr_debug(fmt, ...)					\
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
-#define dynamic_dev_dbg(dev, format, ...)				\
+#define dynamic_dev_dbg(dev, fmt, ...)					\
 	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
 #endif
 
-- 
1.7.0.4

