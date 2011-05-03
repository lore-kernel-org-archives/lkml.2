Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1ECXOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:14:52 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50160 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab1ECXOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:48 -0400
Message-Id: <20110503231425.062529119@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>
Subject: [RFC patch 06/32] trace event jbd2 remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-jbd2-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Theodore Ts'o <tytso@mit.edu>
---
 include/trace/events/jbd2.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6-lttng/include/trace/events/jbd2.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/jbd2.h
+++ linux-2.6-lttng/include/trace/events/jbd2.h
@@ -28,7 +28,7 @@ TRACE_EVENT(jbd2_checkpoint,
 
 	TP_printk("dev %s result %d",
 		  jbd2_dev_to_name(__entry->dev), __entry->result)
-);
+)
 
 DECLARE_EVENT_CLASS(jbd2_commit,
 
@@ -51,35 +51,35 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 	TP_printk("dev %s transaction %d sync %d",
 		  jbd2_dev_to_name(__entry->dev), __entry->transaction,
 		  __entry->sync_commit)
-);
+)
 
 DEFINE_EVENT(jbd2_commit, jbd2_start_commit,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
-);
+)
 
 DEFINE_EVENT(jbd2_commit, jbd2_commit_locking,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
-);
+)
 
 DEFINE_EVENT(jbd2_commit, jbd2_commit_flushing,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
-);
+)
 
 DEFINE_EVENT(jbd2_commit, jbd2_commit_logging,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
-);
+)
 
 TRACE_EVENT(jbd2_end_commit,
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
@@ -103,7 +103,7 @@ TRACE_EVENT(jbd2_end_commit,
 	TP_printk("dev %s transaction %d sync %d head %d",
 		  jbd2_dev_to_name(__entry->dev), __entry->transaction,
 		  __entry->sync_commit, __entry->head)
-);
+)
 
 TRACE_EVENT(jbd2_submit_inode_data,
 	TP_PROTO(struct inode *inode),
@@ -122,7 +122,7 @@ TRACE_EVENT(jbd2_submit_inode_data,
 
 	TP_printk("dev %s ino %lu",
 		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino)
-);
+)
 
 TRACE_EVENT(jbd2_run_stats,
 	TP_PROTO(dev_t dev, unsigned long tid,
@@ -166,7 +166,7 @@ TRACE_EVENT(jbd2_run_stats,
 		  jiffies_to_msecs(__entry->logging),
 		  __entry->handle_count, __entry->blocks,
 		  __entry->blocks_logged)
-);
+)
 
 TRACE_EVENT(jbd2_checkpoint_stats,
 	TP_PROTO(dev_t dev, unsigned long tid,
@@ -197,7 +197,7 @@ TRACE_EVENT(jbd2_checkpoint_stats,
 		  jbd2_dev_to_name(__entry->dev), __entry->tid,
 		  jiffies_to_msecs(__entry->chp_time),
 		  __entry->forced_to_close, __entry->written, __entry->dropped)
-);
+)
 
 TRACE_EVENT(jbd2_cleanup_journal_tail,
 
@@ -225,7 +225,7 @@ TRACE_EVENT(jbd2_cleanup_journal_tail,
 	TP_printk("dev %s from %u to %u offset %lu freed %lu",
 		  jbd2_dev_to_name(__entry->dev), __entry->tail_sequence,
 		  __entry->first_tid, __entry->block_nr, __entry->freed)
-);
+)
 
 #endif /* _TRACE_JBD2_H */
 

