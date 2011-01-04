Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab1ADXur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:50:47 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37879 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1ADXup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:50:45 -0500
X-Greylist: delayed 1576 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jan 2011 18:50:38 EST
Message-Id: <20110104232419.610653574@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 18:16:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC patch 4/5] tracepoint trace event add missing comma
References: <20110104231629.996422888@efficios.com>
Content-Disposition: inline; filename=tracepoint-trace-event-add-missing-comma.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  4 Jan 2011 23:24:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: documentation cleanup.

Add missing comma within the TRACE_EVENT() example in tracepoint.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/tracepoint.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/tracepoint.h
+++ linux-2.6-lttng/include/linux/tracepoint.h
@@ -312,7 +312,7 @@ static inline void tracepoint_update_pro
  *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
  *		__entry->next_pid	= next->pid;
  *		__entry->next_prio	= next->prio;
- *	)
+ *	),
  *
  *	*
  *	* Formatted output of a trace record via TP_printk().

