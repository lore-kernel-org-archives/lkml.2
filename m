Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1AIVK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:10:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:38230 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab1AIVKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:10:55 -0500
Date: Sun, 9 Jan 2011 21:10:23 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, mathieu.desnoyers@efficios.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110106184532.GA2526@Krystal>
References: <20110106184532.GA2526@Krystal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing/trivial: Add missing comma in TRACE_EVENT comment
Message-ID: <tip-ec6e7c3ae39cb1dc279b5274aaaadd09ff8e224b@git.kernel.org>
Git-Commit-ID: ec6e7c3ae39cb1dc279b5274aaaadd09ff8e224b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 09 Jan 2011 21:10:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec6e7c3ae39cb1dc279b5274aaaadd09ff8e224b
Gitweb:     http://git.kernel.org/tip/ec6e7c3ae39cb1dc279b5274aaaadd09ff8e224b
Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate: Thu, 6 Jan 2011 13:45:32 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 7 Jan 2011 20:53:35 -0500

tracing/trivial: Add missing comma in TRACE_EVENT comment

Add missing comma within the TRACE_EVENT() example in tracepoint.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20110106184532.GA2526@Krystal>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index d3e4f87..899103c 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -326,7 +326,7 @@ do_trace:								\
  *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
  *		__entry->next_pid	= next->pid;
  *		__entry->next_prio	= next->prio;
- *	)
+ *	),
  *
  *	*
  *	* Formatted output of a trace record via TP_printk().
