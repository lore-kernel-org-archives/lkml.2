Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1AHUQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 15:16:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34087 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1AHUQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 15:16:46 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=lOMj4pAeCz0A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=9N9BuVJ7uqSexswuFnMA:9 a=R-xhAxCYZwT0r4trxDcA:7 a=qXnG6qZbNF061IUdI16k4smUiz8A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110108201559.130182944@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 08 Jan 2011 15:15:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7] [GIT PULL][2.6.38] tracing: updates and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Jason Baron (1):
      dynamic debug: Fix build issue with older gcc

Lai Jiangshan (1):
      tracepoint: Add __rcu annotation

Li Zefan (1):
      tracing: Fix preempt count leak

Mathieu Desnoyers (3):
      tracing/trivial: Add missing comma in TRACE_EVENT comment
      tracing: remove duplicate null-pointer check in skb tracepoint
      tracing: Fix TRACE_EVENT power tracepoint creation

Steven Rostedt (1):
      tracing: Include module.h in define_trace.h

----
 include/linux/dynamic_debug.h |   18 ++++--------------
 include/linux/tracepoint.h    |    4 ++--
 include/trace/define_trace.h  |   10 ++++++++++
 include/trace/events/skb.h    |    4 +---
 kernel/Makefile               |    1 +
 kernel/trace/Makefile         |    2 +-
 kernel/trace/trace.c          |    6 ++----
 lib/dynamic_debug.c           |    9 ++++-----
 8 files changed, 25 insertions(+), 29 deletions(-)
