Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0C3DAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 23:00:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab0C3DAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 23:00:09 -0400
X-Authority-Analysis: v=1.1 cv=8Rq9yliVGc3GxcN10kx+g7e/eWPAtZnInWtRlahw0rA= c=1 sm=0 a=3ZfRqFL5B9AA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=OhcDZF3sqg2jO_E0CksA:9 a=531EBu4IW1d2itXw4wr7hi87hQUA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100330025800.713540457@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 29 Mar 2010 22:58:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL][v2.6.34] tracing: fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I rebased my branch against yours and removed the module patch
since it looks like it is no longer urgent. I moved it over to
my core branch along with a fix to the compile error you saw with it.
I'll be pushing that later this week.

These two patchs still should go into 34.

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Julia Lawall (1):
      ring-buffer: Add missing unlock

Li Zefan (1):
      tracing: Fix lockdep warning in global_clock()

----
 kernel/trace/ring_buffer.c |    8 +++++---
 kernel/trace/trace_clock.c |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)
