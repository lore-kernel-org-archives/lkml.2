Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2KDNAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:00:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49513 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab2KDNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:00:49 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 11/13] HW-latency: fix a warnning in previous patch
Date: Sun,  4 Nov 2012 20:59:42 -0500
Message-Id: <1352080784-30839-12-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/misc/hw_latency_test.c:52:7: warning: "CONFIG_X86_32" is not defined [-Wundef]

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 drivers/misc/hw_latency_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
index 6e69d31..bcce8f4 100644
--- a/drivers/misc/hw_latency_test.c
+++ b/drivers/misc/hw_latency_test.c
@@ -49,7 +49,7 @@ static struct task_struct *kthread;
 #ifdef CONFIG_X86_64
 static u8 *__start = (u8 *)0xffff880000000000;
 static u8 *__end = (u8 *)0xffffc7ffffffffff;
-#elif CONFIG_X86_32
+#else
 static u8 *__start = (u8 *)0xc0000000;
 static u8 *__end = (u8 *)0xffffffff;
 #endif
-- 
1.7.12.1

