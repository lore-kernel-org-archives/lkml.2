Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab0KSWLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:11:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34911 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab0KSWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:11:51 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=fzZvDqAvlE4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=JFGn9L3haMkXX31gDwgA:9 a=GFKMjertZwnlKdkjaPDCAoIfNNgA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101119221122.946280474@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 19 Nov 2010 17:11:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (1):
      tracing/events: Show real number in array fields

Wu Zhangjin (1):
      ftrace: Speed up recordmcount

----
 include/linux/ftrace_event.h |    4 ++++
 include/trace/ftrace.h       |   14 ++++++++++----
 kernel/trace/trace_events.c  |    6 ++++++
 kernel/trace/trace_export.c  |   14 ++++++++++----
 scripts/Makefile.build       |   13 +++++++++----
 5 files changed, 39 insertions(+), 12 deletions(-)
