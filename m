Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0D1BiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:38:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab0D1BiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:38:07 -0400
X-Authority-Analysis: v=1.1 cv=m27xf9DC4olkrNDaWzGlhfWN1WyLlD0+t5Z5YaFh7bA= c=1 sm=0 a=ItLc2Uoa3lMA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=dhN3IcxlhjfN05jVP14A:9 a=E1rZZCYYar6qwpUjn_Rb_g8Px6MA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100428012723.119106602@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Apr 2010 21:27:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/8] [GIT PULL] tracing: various updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Chase Douglas (2):
      tracing: Add documentation for trace commands mod, traceon/traceoff
      tracing: Show sample std dev in function profiling

David Miller (1):
      ring-buffer: Make non-consuming read less expensive with lots of cpus.

Jiri Olsa (3):
      tracing: Add ftrace events for graph tracer
      tracing: Have graph flags passed in to ouput functions
      tracing: Add graph output support for irqsoff tracer

Steven Rostedt (2):
      ring-buffer: Make benchmark handle missed events
      tracing: Fix sleep time function profiling

----
 Documentation/trace/ftrace.txt       |   44 ++++++
 include/linux/ftrace.h               |   15 ++-
 include/linux/ring_buffer.h          |    4 +-
 kernel/trace/ftrace.c                |   30 ++++-
 kernel/trace/ring_buffer.c           |   64 +++++++--
 kernel/trace/ring_buffer_benchmark.c |    3 +-
 kernel/trace/trace.c                 |   46 ++++--
 kernel/trace/trace.h                 |   27 +++-
 kernel/trace/trace_functions_graph.c |  164 +++++++++++++--------
 kernel/trace/trace_irqsoff.c         |  271 ++++++++++++++++++++++++++++++++--
 10 files changed, 560 insertions(+), 108 deletions(-)
