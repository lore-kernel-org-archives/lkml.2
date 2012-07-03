Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab2GCOUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:20:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2GCOUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:20:19 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched/debug: Fix printing format of next_balance
Date: Tue,  3 Jul 2012 23:19:09 +0900
Message-Id: <1341325149-3791-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use P() for the next_balance since it's in jiffies not nsec.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/sched/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index c09a4e79f5d0..a408a17a1d33 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -280,7 +280,7 @@ do {									\
 	P(nr_switches);
 	P(nr_load_updates);
 	P(nr_uninterruptible);
-	PN(next_balance);
+	P(next_balance);
 	P(curr->pid);
 	PN(clock);
 	P(cpu_load[0]);
-- 
1.7.9.2

