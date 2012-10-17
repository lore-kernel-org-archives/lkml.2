Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2JQGJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:09:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43258 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752515Ab2JQGJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:09:21 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 17/23] printk: Make wait_queue_head_t printk_log_wait extern
Date: Tue, 16 Oct 2012 23:06:21 -0700
Message-Id: <bb441994031f5ea3357f1702530deb4e8e1eaabf.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the variable to the .h file too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk_log.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/printk/printk_log.h b/kernel/printk/printk_log.h
index 0327f8d..e846f1d 100644
--- a/kernel/printk/printk_log.h
+++ b/kernel/printk/printk_log.h
@@ -93,6 +93,7 @@ struct printk_log {
 #define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 
 extern raw_spinlock_t printk_logbuf_lock;
+extern wait_queue_head_t printk_log_wait;
 extern u64 printk_log_first_seq;
 extern u32 printk_log_first_idx;
 extern u64 printk_log_next_seq;
-- 
1.7.10.4

