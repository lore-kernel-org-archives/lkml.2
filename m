Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0IODEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 23:04:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33499 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0IODEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 23:04:04 -0400
X-Authority-Analysis: v=1.1 cv=2ipXt8Ao/PPbK329gQN1nC6XU/V8QMABDttguNTIlb0= c=1 sm=0 a=0fIHWCe0mwQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=DRqATOM_JJy1SuR1-WQA:9 a=B6UcknrEgR6bw5po1erFBiCefpIA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100915030139.444219083@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Sep 2010 23:01:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] [GIT PULL] tracing: ftrace features and clean ups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This series is based off of your tip/perf/core and does not contain
the changes in the previous git pull request (does not include
my repo's tip/perf/core). This is a separate pull.

Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core-2


Jiri Olsa (1):
      tracing: Add funcgraph-irq option for function graph tracer.

Steven Rostedt (2):
      tracing: Do not trace in irq when funcgraph-irq option is zero
      tracing: Remove leftover FTRACE_ENABLE/DISABLE_MCOUNT enums

----
 kernel/trace/ftrace.c                |   18 +----
 kernel/trace/trace_functions_graph.c |  124 +++++++++++++++++++++++++++++++++-
 2 files changed, 126 insertions(+), 16 deletions(-)

