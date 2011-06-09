Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1FIRbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:31:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab1FIR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:29:14 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Sff775Mul4EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=KptQAqvHqVzwRrhwPwgA:9 a=SNmEBZ7QmHj0cCXluNcA:7 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110609172911.247431641@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:27:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McQuade <tungstentide@gmail.com>
Subject: [PATCH 04/15] ftrace: Fixed an include coding style issue
References: <20110609172744.333794089@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Fixed-an-include-coding-style-issue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul McQuade <tungstentide@gmail.com>

Removed <asm/ftrace.h> because <linux/ftrace.h> was already declared.
Braces of struct's coding style fixed.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul McQuade <tungstentide@gmail.com>
Link: http://lkml.kernel.org/r/4DE59711.3090900@gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ee417f..e153807 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -32,7 +32,6 @@
 
 #include <trace/events/sched.h>
 
-#include <asm/ftrace.h>
 #include <asm/setup.h>
 
 #include "trace_output.h"
@@ -82,8 +81,7 @@ static int ftrace_disabled __read_mostly;
 
 static DEFINE_MUTEX(ftrace_lock);
 
-static struct ftrace_ops ftrace_list_end __read_mostly =
-{
+static struct ftrace_ops ftrace_list_end __read_mostly = {
 	.func		= ftrace_stub,
 };
 
@@ -785,8 +783,7 @@ static void unregister_ftrace_profiler(void)
 	unregister_ftrace_graph();
 }
 #else
-static struct ftrace_ops ftrace_profile_ops __read_mostly =
-{
+static struct ftrace_ops ftrace_profile_ops __read_mostly = {
 	.func		= function_profile_call,
 };
 
-- 
1.7.4.4


