Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0HKTCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:02:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab0HKTCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:02:32 -0400
X-Authority-Analysis: v=1.1 cv=mWMe3HXt1P3ELXxrmMgI9QKdSRnwjSxQbBh3ay0KAh4= c=1 sm=0 a=nOxzHNGvA08A:10 a=GzHTLUccyWwA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=VwQbUJbxAAAA:8 a=0rrXNoU6ubKoRiRc5X0A:9 a=_rkWhbbM9HLuzx1SPZy60n6HXAEA:4 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Message-Id: <20100811190143.688551293@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 11 Aug 2010 15:01:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: updates for 2.6.36 and stable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Huang Ying (1):
      tracing: Fix ring_buffer_read_page reading out of page boundary

Shaohua Li (1):
      tracing: Fix an unallocated memory access in function_graph

----
 kernel/trace/ring_buffer.c           |    3 +++
 kernel/trace/trace_functions_graph.c |   10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)
