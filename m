Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0IUClm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:41:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52063 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0IUClk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:41:40 -0400
X-Authority-Analysis: v=1.1 cv=xllhIT3+0iZermAJQK9ulaVoiSOvD1gApk/LON5m1IU= c=1 sm=0 a=lVFa6xI0ZTUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=lL3mehLf_2ilrvnqE1UA:9 a=s10GtKyNMUhXH5smcF_WNjMIeJUA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100921024002.672817629@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 20 Sep 2010 22:40:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/4] [GIT PULL] sched: Migrate higher priority tasks less
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/sched/rt tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/sched/rt


Steven Rostedt (4):
      sched: Try not to migrate higher priority RT tasks
      sched: Give CPU bound RT tasks preference
      tracing/sched: Add sched_rt_push and sched_rt_pull tracepoints
      tracing/sched: Add sched_rt_setprio tracepoint

----
 include/trace/events/sched.h |   61 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c               |    1 +
 kernel/sched_rt.c            |   28 +++++++++++-------
 3 files changed, 79 insertions(+), 11 deletions(-)
