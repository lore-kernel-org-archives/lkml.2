Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1BHWTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:19:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1BHWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:22 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=Pv9iijLtDrYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=w23HppMojUkn6IiizGoA:9 a=uB6TLwaKXO6vcbC9mbnMBuIzmQ4A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221612.084294240@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/10] [GIT PULL][v2.6.39] tracing: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Ian Munsie (5):
      tracing/syscalls: Don't add events for unmapped syscalls
      tracing/syscalls: Convert redundant syscall_nr checks into WARN_ON
      tracing/syscalls: Make arch_syscall_addr weak
      tracing/syscalls: Allow arch specific syscall symbol matching
      tracing/syscalls: Early terminate search for sys_ni_syscall

Jiri Olsa (1):
      tracing: Add unstable sched clock note to the warning

Lai Jiangshan (1):
      tracing: Compile time initialization for event flags value

Steven Rostedt (2):
      tracing: Remove obsolete sched_switch tracer
      tracing: Deprecate tracing_enabled for tracing_on

Uwe Kleine-König (1):
      trivial: Fix Steven's Copyright typos

----
 Documentation/trace/ftrace-design.txt |    7 ++
 Documentation/trace/ftrace.txt        |  148 ++++----------------------------
 include/linux/syscalls.h              |   10 ++-
 kernel/trace/ring_buffer.c            |    8 ++-
 kernel/trace/trace.c                  |    4 +
 kernel/trace/trace_sched_switch.c     |   48 -----------
 kernel/trace/trace_syscalls.c         |   42 +++++++---
 scripts/kconfig/streamline_config.pl  |    2 +-
 tools/testing/ktest/ktest.pl          |    2 +-
 9 files changed, 74 insertions(+), 197 deletions(-)
