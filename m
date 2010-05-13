Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab0EMBXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:23:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63144 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561Ab0EMBXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:23:05 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=tgG-GccutD8A:10 a=ADBQPqJMlbwA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=v1RGVX6tXBF9zzVmJuUA:9 a=V3NCMNla1ovYRLYr6D4-RhaaRo0A:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100513012110.558313399@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 12 May 2010 21:21:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [GIT PULL] tracing: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is based off of the last pull request I sent.

Please pull the latest tip/tracing/core-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core-1


Carsten Emde (1):
      tracing/sched: Fix task states in sched switch event

Li Zefan (1):
      tracing: Fix function declarations if !CONFIG_STACKTRACE

Steven Rostedt (2):
      tracing: Allow mmio tracer to display trace_printk() and other events
      tracing: Update branch trace to new event API

----
 fs/proc/array.c                |   25 +++++++++++++------------
 include/linux/sched.h          |   38 ++++++++++++++++++++++++++++++++++++--
 include/trace/events/sched.h   |   12 +++++++++---
 kernel/trace/trace.h           |    4 ++--
 kernel/trace/trace_branch.c    |    8 ++++++--
 kernel/trace/trace_mmiotrace.c |    3 ++-
 6 files changed, 68 insertions(+), 22 deletions(-)
