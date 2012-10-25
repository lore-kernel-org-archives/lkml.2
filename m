Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883Ab2JYDqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:46:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42372 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934515Ab2JYDqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:46:34 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH V2 17/23] printk: Make wait_queue_head_t printk_log_wait extern
Date: Wed, 24 Oct 2012 20:43:52 -0700
Message-Id: <9bd8d74c126fd809c4e0b6f66568139290dfd58e.1351135989.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351135988.git.joe@perches.com>
References: <cover.1351135988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the variable to the .h file too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk_log.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
1.7.8.112.g3fd21

