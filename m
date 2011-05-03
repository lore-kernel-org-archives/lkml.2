Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1ECXPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:15:18 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:33226 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab1ECXPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:15:12 -0400
Message-Id: <20110503231427.570587840@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC patch 21/32] trace event vmscan remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-vmscan-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:27 +0000
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
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: Larry Woodman <lwoodman@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/trace/events/vmscan.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6-lttng/include/trace/events/vmscan.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/vmscan.h
+++ linux-2.6-lttng/include/trace/events/vmscan.h
@@ -49,7 +49,7 @@ TRACE_EVENT(mm_vmscan_kswapd_sleep,
 	),
 
 	TP_printk("nid=%d", __entry->nid)
-);
+)
 
 TRACE_EVENT(mm_vmscan_kswapd_wake,
 
@@ -68,7 +68,7 @@ TRACE_EVENT(mm_vmscan_kswapd_wake,
 	),
 
 	TP_printk("nid=%d order=%d", __entry->nid, __entry->order)
-);
+)
 
 TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
@@ -92,7 +92,7 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 		__entry->nid,
 		__entry->zid,
 		__entry->order)
-);
+)
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
@@ -116,28 +116,28 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 		__entry->order,
 		__entry->may_writepage,
 		show_gfp_flags(__entry->gfp_flags))
-);
+)
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
 
 	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags),
 
 	TP_ARGS(order, may_writepage, gfp_flags)
-);
+)
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
 	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags),
 
 	TP_ARGS(order, may_writepage, gfp_flags)
-);
+)
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
 
 	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags),
 
 	TP_ARGS(order, may_writepage, gfp_flags)
-);
+)
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
 
@@ -154,28 +154,28 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 	),
 
 	TP_printk("nr_reclaimed=%lu", __entry->nr_reclaimed)
-);
+)
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
 
 	TP_PROTO(unsigned long nr_reclaimed),
 
 	TP_ARGS(nr_reclaimed)
-);
+)
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
 
 	TP_PROTO(unsigned long nr_reclaimed),
 
 	TP_ARGS(nr_reclaimed)
-);
+)
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
 
 	TP_PROTO(unsigned long nr_reclaimed),
 
 	TP_ARGS(nr_reclaimed)
-);
+)
 
 
 DECLARE_EVENT_CLASS(mm_vmscan_lru_isolate_template,
@@ -222,7 +222,7 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 		__entry->nr_lumpy_taken,
 		__entry->nr_lumpy_dirty,
 		__entry->nr_lumpy_failed)
-);
+)
 
 DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_lru_isolate,
 
@@ -237,7 +237,7 @@ DEFINE_EVENT(mm_vmscan_lru_isolate_templ
 
 	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode)
 
-);
+)
 
 DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_memcg_isolate,
 
@@ -252,7 +252,7 @@ DEFINE_EVENT(mm_vmscan_lru_isolate_templ
 
 	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode)
 
-);
+)
 
 TRACE_EVENT(mm_vmscan_writepage,
 
@@ -275,7 +275,7 @@ TRACE_EVENT(mm_vmscan_writepage,
 		__entry->page,
 		page_to_pfn(__entry->page),
 		show_reclaim_flags(__entry->reclaim_flags))
-);
+)
 
 TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 
@@ -308,7 +308,7 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 		__entry->nr_scanned, __entry->nr_reclaimed,
 		__entry->priority,
 		show_reclaim_flags(__entry->reclaim_flags))
-);
+)
 
 
 #endif /* _TRACE_VMSCAN_H */

