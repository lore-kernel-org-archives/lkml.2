Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1FHMaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:30:09 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:47811 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1FHMaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:30:07 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] microblaze: remove duplicated prototype of start_thread()
Date: Wed,  8 Jun 2011 14:30:05 +0200
Message-Id: <1307536205-20377-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prototype for start_thread() is already present in the MMU/NOMMU
independent part of the file. Remove the duplicate.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/microblaze/include/asm/processor.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index aed2a6b..7283bfb 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -125,9 +125,6 @@ struct thread_struct {
 	.pgdir = swapper_pg_dir, \
 }
 
-/* Do necessary setup to start up a newly executed thread.  */
-void start_thread(struct pt_regs *regs,
-		unsigned long pc, unsigned long usp);
 
 /* Free all resources held by a thread. */
 extern inline void release_thread(struct task_struct *dead_task)
-- 
1.5.6.5

