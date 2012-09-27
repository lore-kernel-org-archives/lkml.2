Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2I0SUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:20:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43482 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab2I0SUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:20:02 -0400
From: Josh Taylor <joshua.taylor0@gmail.com>
To: akpm@linux-foundation.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, Josh Taylor <joshua.taylor0@gmail.com>
Subject: [PATCH 3/3] Kernel: Corrected space error after ','
Date: Thu, 27 Sep 2012 14:19:28 -0400
Message-Id: <1348769968-2696-1-git-send-email-joshua.taylor0@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Taylor <joshua.taylor0@gmail.com>
---
 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index e1b2822..176d58c 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -100,7 +100,7 @@ void panic(const char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+	printk(KERN_EMERG "Kernel panic - not syncing: %s\n", buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	/*
 	 * Avoid nested stack-dumping if a panic occurs during oops processing
-- 
1.7.9.5

