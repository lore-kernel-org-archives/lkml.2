Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1KGIVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 03:21:23 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:54748 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1KGIVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 03:21:22 -0500
From: Richard Weinberger <richard@nod.at>
To: rostedt@goodmis.org
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/3] trace: Remove kernel_lock annotations
Date: Mon,  7 Nov 2011 09:23:22 +0100
Message-Id: <1320654202-4433-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is gone, these annotations are useless.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 kernel/trace/trace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f2bd275..1f83ac54 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -726,8 +726,6 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
  * Register a new plugin tracer.
  */
 int register_tracer(struct tracer *type)
-__releases(kernel_lock)
-__acquires(kernel_lock)
 {
 	struct tracer *t;
 	int ret = 0;
-- 
1.7.7

