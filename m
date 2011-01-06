Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1AFSpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:45:34 -0500
Received: from mail.openrapids.net ([64.15.138.104]:48769 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752927Ab1AFSpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:45:33 -0500
Date: Thu, 6 Jan 2011 13:45:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] tracepoint trace event add missing comma
Message-ID: <20110106184532.GA2526@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:44:33 up 43 days, 23:47,  5 users,  load average: 0.12, 0.09,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
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

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
