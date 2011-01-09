Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1AIWII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:08:08 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:32789 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab1AIWFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:43 -0500
Message-Id: <20110109220512.350674665@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC patch 26/28] trace event video gpu remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-video-gpu-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:12 +0000
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
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Dave Airlie <airlied@redhat.com>
CC: Chris Wilson <chris@chris-wilson.co.uk>
CC: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/gpu/drm/drm_trace.h       |    6 ++---
 drivers/gpu/drm/i915/i915_trace.h |   40 +++++++++++++++++++-------------------
 2 files changed, 23 insertions(+), 23 deletions(-)

Index: linux-2.6-lttng/drivers/gpu/drm/drm_trace.h
===================================================================
--- linux-2.6-lttng.orig/drivers/gpu/drm/drm_trace.h
+++ linux-2.6-lttng/drivers/gpu/drm/drm_trace.h
@@ -22,7 +22,7 @@ TRACE_EVENT(drm_vblank_event,
 		    __entry->seq = seq;
 		    ),
 	    TP_printk("crtc=%d, seq=%d", __entry->crtc, __entry->seq)
-);
+)
 
 TRACE_EVENT(drm_vblank_event_queued,
 	    TP_PROTO(pid_t pid, int crtc, unsigned int seq),
@@ -39,7 +39,7 @@ TRACE_EVENT(drm_vblank_event_queued,
 		    ),
 	    TP_printk("pid=%d, crtc=%d, seq=%d", __entry->pid, __entry->crtc, \
 		      __entry->seq)
-);
+)
 
 TRACE_EVENT(drm_vblank_event_delivered,
 	    TP_PROTO(pid_t pid, int crtc, unsigned int seq),
@@ -56,7 +56,7 @@ TRACE_EVENT(drm_vblank_event_delivered,
 		    ),
 	    TP_printk("pid=%d, crtc=%d, seq=%d", __entry->pid, __entry->crtc, \
 		      __entry->seq)
-);
+)
 
 #endif /* _DRM_TRACE_H_ */
 
Index: linux-2.6-lttng/drivers/gpu/drm/i915/i915_trace.h
===================================================================
--- linux-2.6-lttng.orig/drivers/gpu/drm/i915/i915_trace.h
+++ linux-2.6-lttng/drivers/gpu/drm/i915/i915_trace.h
@@ -31,7 +31,7 @@ TRACE_EVENT(i915_gem_object_create,
 			   ),
 
 	    TP_printk("obj=%p, size=%u", __entry->obj, __entry->size)
-);
+)
 
 TRACE_EVENT(i915_gem_object_bind,
 
@@ -51,7 +51,7 @@ TRACE_EVENT(i915_gem_object_bind,
 
 	    TP_printk("obj=%p, gtt_offset=%08x",
 		      __entry->obj, __entry->gtt_offset)
-);
+)
 
 TRACE_EVENT(i915_gem_object_change_domain,
 
@@ -74,7 +74,7 @@ TRACE_EVENT(i915_gem_object_change_domai
 	    TP_printk("obj=%p, read=%04x, write=%04x",
 		      __entry->obj,
 		      __entry->read_domains, __entry->write_domain)
-);
+)
 
 TRACE_EVENT(i915_gem_object_get_fence,
 
@@ -96,7 +96,7 @@ TRACE_EVENT(i915_gem_object_get_fence,
 
 	    TP_printk("obj=%p, fence=%d, tiling=%d",
 		      __entry->obj, __entry->fence, __entry->tiling_mode)
-);
+)
 
 DECLARE_EVENT_CLASS(i915_gem_object,
 
@@ -113,28 +113,28 @@ DECLARE_EVENT_CLASS(i915_gem_object,
 			   ),
 
 	    TP_printk("obj=%p", __entry->obj)
-);
+)
 
 DEFINE_EVENT(i915_gem_object, i915_gem_object_clflush,
 
 	    TP_PROTO(struct drm_gem_object *obj),
 
 	    TP_ARGS(obj)
-);
+)
 
 DEFINE_EVENT(i915_gem_object, i915_gem_object_unbind,
 
 	    TP_PROTO(struct drm_gem_object *obj),
 
 	    TP_ARGS(obj)
-);
+)
 
 DEFINE_EVENT(i915_gem_object, i915_gem_object_destroy,
 
 	    TP_PROTO(struct drm_gem_object *obj),
 
 	    TP_ARGS(obj)
-);
+)
 
 /* batch tracing */
 
@@ -156,7 +156,7 @@ TRACE_EVENT(i915_gem_request_submit,
 			   ),
 
 	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
-);
+)
 
 TRACE_EVENT(i915_gem_request_flush,
 
@@ -182,7 +182,7 @@ TRACE_EVENT(i915_gem_request_flush,
 	    TP_printk("dev=%u, seqno=%u, flush=%04x, invalidate=%04x",
 		      __entry->dev, __entry->seqno,
 		      __entry->flush_domains, __entry->invalidate_domains)
-);
+)
 
 DECLARE_EVENT_CLASS(i915_gem_request,
 
@@ -201,35 +201,35 @@ DECLARE_EVENT_CLASS(i915_gem_request,
 			   ),
 
 	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
-);
+)
 
 DEFINE_EVENT(i915_gem_request, i915_gem_request_complete,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
 	    TP_ARGS(dev, seqno)
-);
+)
 
 DEFINE_EVENT(i915_gem_request, i915_gem_request_retire,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
 	    TP_ARGS(dev, seqno)
-);
+)
 
 DEFINE_EVENT(i915_gem_request, i915_gem_request_wait_begin,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
 	    TP_ARGS(dev, seqno)
-);
+)
 
 DEFINE_EVENT(i915_gem_request, i915_gem_request_wait_end,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
 	    TP_ARGS(dev, seqno)
-);
+)
 
 DECLARE_EVENT_CLASS(i915_ring,
 
@@ -246,21 +246,21 @@ DECLARE_EVENT_CLASS(i915_ring,
 			   ),
 
 	    TP_printk("dev=%u", __entry->dev)
-);
+)
 
 DEFINE_EVENT(i915_ring, i915_ring_wait_begin,
 
 	    TP_PROTO(struct drm_device *dev),
 
 	    TP_ARGS(dev)
-);
+)
 
 DEFINE_EVENT(i915_ring, i915_ring_wait_end,
 
 	    TP_PROTO(struct drm_device *dev),
 
 	    TP_ARGS(dev)
-);
+)
 
 TRACE_EVENT(i915_flip_request,
 	    TP_PROTO(int plane, struct drm_gem_object *obj),
@@ -278,7 +278,7 @@ TRACE_EVENT(i915_flip_request,
 		    ),
 
 	    TP_printk("plane=%d, obj=%p", __entry->plane, __entry->obj)
-);
+)
 
 TRACE_EVENT(i915_flip_complete,
 	    TP_PROTO(int plane, struct drm_gem_object *obj),
@@ -296,7 +296,7 @@ TRACE_EVENT(i915_flip_complete,
 		    ),
 
 	    TP_printk("plane=%d, obj=%p", __entry->plane, __entry->obj)
-);
+)
 
 #endif /* _I915_TRACE_H_ */
 

