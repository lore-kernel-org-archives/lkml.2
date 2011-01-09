Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1AIWFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:05:53 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:56521 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1AIWFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:45 -0500
Message-Id: <20110109220508.754470770@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC patch 04/28] trace event block remove semicolumns
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-block-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:09 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/block.h |   46 +++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

Index: linux-2.6-lttng/include/trace/events/block.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/block.h
+++ linux-2.6-lttng/include/trace/events/block.h
@@ -40,7 +40,7 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
 		  __entry->rwbs, __get_str(cmd),
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->errors)
-);
+)
 
 /**
  * block_rq_abort - abort block operation request
@@ -57,7 +57,7 @@ DEFINE_EVENT(block_rq_with_error, block_
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
 	TP_ARGS(q, rq)
-);
+)
 
 /**
  * block_rq_requeue - place block IO request back on a queue
@@ -73,7 +73,7 @@ DEFINE_EVENT(block_rq_with_error, block_
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
 	TP_ARGS(q, rq)
-);
+)
 
 /**
  * block_rq_complete - block IO operation completed by device driver
@@ -91,7 +91,7 @@ DEFINE_EVENT(block_rq_with_error, block_
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
 	TP_ARGS(q, rq)
-);
+)
 
 DECLARE_EVENT_CLASS(block_rq,
 
@@ -128,7 +128,7 @@ DECLARE_EVENT_CLASS(block_rq,
 		  __entry->rwbs, __entry->bytes, __get_str(cmd),
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->comm)
-);
+)
 
 /**
  * block_rq_insert - insert block operation request into queue
@@ -145,7 +145,7 @@ DEFINE_EVENT(block_rq, block_rq_insert,
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
 	TP_ARGS(q, rq)
-);
+)
 
 /**
  * block_rq_issue - issue pending block IO request operation to device driver
@@ -160,7 +160,7 @@ DEFINE_EVENT(block_rq, block_rq_issue,
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
 	TP_ARGS(q, rq)
-);
+)
 
 /**
  * block_bio_bounce - used bounce buffer when processing block operation
@@ -200,7 +200,7 @@ TRACE_EVENT(block_bio_bounce,
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->comm)
-);
+)
 
 /**
  * block_bio_complete - completed all work on the block operation
@@ -237,7 +237,7 @@ TRACE_EVENT(block_bio_complete,
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->error)
-);
+)
 
 DECLARE_EVENT_CLASS(block_bio,
 
@@ -265,7 +265,7 @@ DECLARE_EVENT_CLASS(block_bio,
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->comm)
-);
+)
 
 /**
  * block_bio_backmerge - merging block operation to the end of an existing operation
@@ -280,7 +280,7 @@ DEFINE_EVENT(block_bio, block_bio_backme
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
 	TP_ARGS(q, bio)
-);
+)
 
 /**
  * block_bio_frontmerge - merging block operation to the beginning of an existing operation
@@ -295,7 +295,7 @@ DEFINE_EVENT(block_bio, block_bio_frontm
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
 	TP_ARGS(q, bio)
-);
+)
 
 /**
  * block_bio_queue - putting new block IO operation in queue
@@ -309,7 +309,7 @@ DEFINE_EVENT(block_bio, block_bio_queue,
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
 	TP_ARGS(q, bio)
-);
+)
 
 DECLARE_EVENT_CLASS(block_get_rq,
 
@@ -338,7 +338,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->comm)
-);
+)
 
 /**
  * block_getrq - get a free request entry in queue for block IO operations
@@ -354,7 +354,7 @@ DEFINE_EVENT(block_get_rq, block_getrq,
 	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
 
 	TP_ARGS(q, bio, rw)
-);
+)
 
 /**
  * block_sleeprq - waiting to get a free request entry in queue for block IO operation
@@ -372,7 +372,7 @@ DEFINE_EVENT(block_get_rq, block_sleeprq
 	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
 
 	TP_ARGS(q, bio, rw)
-);
+)
 
 /**
  * block_plug - keep operations requests in request queue
@@ -397,7 +397,7 @@ TRACE_EVENT(block_plug,
 	),
 
 	TP_printk("[%s]", __entry->comm)
-);
+)
 
 DECLARE_EVENT_CLASS(block_unplug,
 
@@ -416,7 +416,7 @@ DECLARE_EVENT_CLASS(block_unplug,
 	),
 
 	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
-);
+)
 
 /**
  * block_unplug_timer - timed release of operations requests in queue to device driver
@@ -430,7 +430,7 @@ DEFINE_EVENT(block_unplug, block_unplug_
 	TP_PROTO(struct request_queue *q),
 
 	TP_ARGS(q)
-);
+)
 
 /**
  * block_unplug_io - release of operations requests in request queue
@@ -444,7 +444,7 @@ DEFINE_EVENT(block_unplug, block_unplug_
 	TP_PROTO(struct request_queue *q),
 
 	TP_ARGS(q)
-);
+)
 
 /**
  * block_split - split a single bio struct into two bio structs
@@ -485,7 +485,7 @@ TRACE_EVENT(block_split,
 		  (unsigned long long)__entry->sector,
 		  (unsigned long long)__entry->new_sector,
 		  __entry->comm)
-);
+)
 
 /**
  * block_remap - map request for a partition to the raw device
@@ -528,7 +528,7 @@ TRACE_EVENT(block_remap,
 		  __entry->nr_sector,
 		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
 		  (unsigned long long)__entry->old_sector)
-);
+)
 
 /**
  * block_rq_remap - map request for a block operation request
@@ -572,7 +572,7 @@ TRACE_EVENT(block_rq_remap,
 		  __entry->nr_sector,
 		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
 		  (unsigned long long)__entry->old_sector)
-);
+)
 
 #endif /* _TRACE_BLOCK_H */
 

