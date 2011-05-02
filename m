Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab1EBVij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:38:39 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39956 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab1EBVif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:38:35 -0400
Message-Id: <20110502213212.349674198@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC patch 07/32] trace event kmem remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-kmem-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:12 +0000
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
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: Larry Woodman <lwoodman@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/trace/events/kmem.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6-lttng/include/trace/events/kmem.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/kmem.h
+++ linux-2.6-lttng/include/trace/events/kmem.h
@@ -40,7 +40,7 @@ DECLARE_EVENT_CLASS(kmem_alloc,
 		__entry->bytes_req,
 		__entry->bytes_alloc,
 		show_gfp_flags(__entry->gfp_flags))
-);
+)
 
 DEFINE_EVENT(kmem_alloc, kmalloc,
 
@@ -48,7 +48,7 @@ DEFINE_EVENT(kmem_alloc, kmalloc,
 		 size_t bytes_req, size_t bytes_alloc, gfp_t gfp_flags),
 
 	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags)
-);
+)
 
 DEFINE_EVENT(kmem_alloc, kmem_cache_alloc,
 
@@ -56,7 +56,7 @@ DEFINE_EVENT(kmem_alloc, kmem_cache_allo
 		 size_t bytes_req, size_t bytes_alloc, gfp_t gfp_flags),
 
 	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags)
-);
+)
 
 DECLARE_EVENT_CLASS(kmem_alloc_node,
 
@@ -94,7 +94,7 @@ DECLARE_EVENT_CLASS(kmem_alloc_node,
 		__entry->bytes_alloc,
 		show_gfp_flags(__entry->gfp_flags),
 		__entry->node)
-);
+)
 
 DEFINE_EVENT(kmem_alloc_node, kmalloc_node,
 
@@ -103,7 +103,7 @@ DEFINE_EVENT(kmem_alloc_node, kmalloc_no
 		 gfp_t gfp_flags, int node),
 
 	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node)
-);
+)
 
 DEFINE_EVENT(kmem_alloc_node, kmem_cache_alloc_node,
 
@@ -112,7 +112,7 @@ DEFINE_EVENT(kmem_alloc_node, kmem_cache
 		 gfp_t gfp_flags, int node),
 
 	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node)
-);
+)
 
 DECLARE_EVENT_CLASS(kmem_free,
 
@@ -131,21 +131,21 @@ DECLARE_EVENT_CLASS(kmem_free,
 	),
 
 	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
-);
+)
 
 DEFINE_EVENT(kmem_free, kfree,
 
 	TP_PROTO(unsigned long call_site, const void *ptr),
 
 	TP_ARGS(call_site, ptr)
-);
+)
 
 DEFINE_EVENT(kmem_free, kmem_cache_free,
 
 	TP_PROTO(unsigned long call_site, const void *ptr),
 
 	TP_ARGS(call_site, ptr)
-);
+)
 
 TRACE_EVENT(mm_page_free_direct,
 
@@ -167,7 +167,7 @@ TRACE_EVENT(mm_page_free_direct,
 			__entry->page,
 			page_to_pfn(__entry->page),
 			__entry->order)
-);
+)
 
 TRACE_EVENT(mm_pagevec_free,
 
@@ -189,7 +189,7 @@ TRACE_EVENT(mm_pagevec_free,
 			__entry->page,
 			page_to_pfn(__entry->page),
 			__entry->cold)
-);
+)
 
 TRACE_EVENT(mm_page_alloc,
 
@@ -218,7 +218,7 @@ TRACE_EVENT(mm_page_alloc,
 		__entry->order,
 		__entry->migratetype,
 		show_gfp_flags(__entry->gfp_flags))
-);
+)
 
 DECLARE_EVENT_CLASS(mm_page,
 
@@ -244,14 +244,14 @@ DECLARE_EVENT_CLASS(mm_page,
 		__entry->order,
 		__entry->migratetype,
 		__entry->order == 0)
-);
+)
 
 DEFINE_EVENT(mm_page, mm_page_alloc_zone_locked,
 
 	TP_PROTO(struct page *page, unsigned int order, int migratetype),
 
 	TP_ARGS(page, order, migratetype)
-);
+)
 
 DEFINE_EVENT_PRINT(mm_page, mm_page_pcpu_drain,
 
@@ -262,7 +262,7 @@ DEFINE_EVENT_PRINT(mm_page, mm_page_pcpu
 	TP_printk("page=%p pfn=%lu order=%d migratetype=%d",
 		__entry->page, page_to_pfn(__entry->page),
 		__entry->order, __entry->migratetype)
-);
+)
 
 TRACE_EVENT(mm_page_alloc_extfrag,
 
@@ -300,7 +300,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->fallback_migratetype,
 		__entry->fallback_order < pageblock_order,
 		__entry->alloc_migratetype == __entry->fallback_migratetype)
-);
+)
 
 #endif /* _TRACE_KMEM_H */
 

