Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1LAVlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:41:37 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43647 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754723Ab1LAVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:41:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: [PATCH 09/11] sched: export task_prio to GPL modules
Date: Thu,  1 Dec 2011 16:41:21 -0500
Message-Id: <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng needs this symbol to prepend the current task dynamic priority
value to events (optional context information).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0e9344a..80dbb09 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5142,6 +5142,7 @@ int task_prio(const struct task_struct *p)
 {
 	return p->prio - MAX_RT_PRIO;
 }
+EXPORT_SYMBOL_GPL(task_prio);
 
 /**
  * task_nice - return the nice value of a given task.
-- 
1.7.5.4

