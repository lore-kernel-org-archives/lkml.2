Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2BCGDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 01:03:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42604 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2BCGDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 01:03:07 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [Patch] cris: remove an unused variable in ptrace_disable()
Date: Fri,  3 Feb 2012 14:02:46 +0800
Message-Id: <1328248969-9829-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'tmp' is unused in this function.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index 511ece9..42ed6c7 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -115,8 +115,6 @@ void user_disable_single_step(struct task_struct *child)
 void
 ptrace_disable(struct task_struct *child)
 {
-	unsigned long tmp;
-
 	/* Deconfigure SPC and S-bit. */
 	user_disable_single_step(child);
 	put_reg(child, PT_SPC, 0);
