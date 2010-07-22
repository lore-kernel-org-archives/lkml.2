Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab0GVUY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:24:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51113 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0GVUYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:24:54 -0400
X-Authority-Analysis: v=1.1 cv=NvN00vXXLC/2Fo3NdLZJXFUM7u9qr/FOWvgMjmHRJhk= c=1 sm=0 a=vPnlRXC0CbEA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=fEOsYTyjfvl5NA60lzgA:9 a=Qq1XSag5JfUtD7BOZ8sA:7 a=4pbDeSHJd98uwuSjXyZ1sF6dpJYA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100722202411.920807480@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Jul 2010 16:24:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7] [GIT PULL] tracing: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Dan Carpenter (1):
      trace: strlen() return doesn't account for the NULL

David Daney (1):
      tracing: Fix $mcount_regex for MIPS in recordmcount.pl

KOSAKI Motohiro (1):
      tracing: Shrink max latency ringbuffer if unnecessary

Lai Jiangshan (1):
      tracing: Reduce latency and remove percpu trace_seq

Li Zefan (1):
      tracing: Allow to disable cmdline recording

Mike Frysinger (1):
      tracing/documentation: Document dynamic ftracer internals

Richard Kennedy (1):
      trace: Reorder struct ring_buffer_per_cpu to remove padding on 64bit

----
 Documentation/trace/ftrace-design.txt |  153 +++++++++++++++++++++++++++++++-
 include/linux/ftrace.h                |    5 +
 include/linux/ftrace_event.h          |   12 ++-
 include/trace/ftrace.h                |   12 +--
 kernel/trace/ring_buffer.c            |    2 +-
 kernel/trace/trace.c                  |   46 ++++++++--
 kernel/trace/trace.h                  |    4 +
 kernel/trace/trace_events.c           |   30 ++++++-
 kernel/trace/trace_irqsoff.c          |    3 +
 kernel/trace/trace_output.c           |    3 -
 kernel/trace/trace_sched_wakeup.c     |    2 +
 scripts/recordmcount.pl               |    2 +-
 12 files changed, 241 insertions(+), 33 deletions(-)
