Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0CYBER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:04:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61884 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0CYBEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:04:16 -0400
X-Authority-Analysis: v=1.0 c=1 a=AVY-5gTO0e4A:10 a=GzHTLUccyWwA:10 a=VwQbUJbxAAAA:8 a=KWMxArFmlDXIuCLb_6IA:9 a=wtYwXOLX3RZFwejOhcDamX969rkA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100325010223.843140579@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 24 Mar 2010 21:02:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2][GIT PULL][v2.6.34] tracing: fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Li Zefan (2):
      tracing: Reduce overhead of module tracepoints
      tracing: Fix lockdep warning in global_clock()

----
 include/linux/module.h        |    6 ++----
 include/trace/events/module.h |   14 +++++++-------
 kernel/module.c               |    3 +--
 kernel/trace/trace_clock.c    |    4 ++--
 4 files changed, 12 insertions(+), 15 deletions(-)
