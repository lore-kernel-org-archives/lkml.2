Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1AOBFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 20:05:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61872 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1AOBFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 20:05:19 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=fwlNDkRQO-EA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=ZxIm5Uz51tWomcq9HaAA:9 a=bSqz_5DaOEpJrgaY-h9qRYIsQAEA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110115010442.446174852@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 Jan 2011 20:04:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL][2.6.38] tracing: clean ups and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Lai Jiangshan (1):
      tracing: Remove syscall_exit_fields

Steven Rostedt (1):
      tracing: Only process module tracepoints once

----
 include/trace/events/module.h |   10 ++++++++++
 kernel/trace/trace_syscalls.c |   33 ++++++++++++---------------------
 2 files changed, 22 insertions(+), 21 deletions(-)

