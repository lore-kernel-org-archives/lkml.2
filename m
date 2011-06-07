Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1FGRIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:08:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49196 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab1FGRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:08:28 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=sKbd4fFnSSkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=VGV-gYFi3XJEmw5GPtwA:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110607170740.235441001@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 07 Jun 2011 13:07:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL][v3.0] tracing: fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


GuoWen Li (1):
      ftrace: Fix possible undefined return code

Steven Rostedt (2):
      kprobes/trace: Fix kprobe selftest for gcc 4.6
      ftrace: Revert 8ab2b7efd ftrace: Remove unnecessary disabling of irqs

----
 kernel/trace/ftrace.c       |    9 ++++++++-
 kernel/trace/trace_kprobe.c |    8 ++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)
