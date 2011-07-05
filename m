Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab1GEMuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:50:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:58314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab1GEMux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:50:53 -0400
Date: Tue, 5 Jul 2011 12:50:45 GMT
From: tip-bot for Paul McQuade <tungstentide@gmail.com>
Message-ID: <tip-bd38c0e6f98326132a691d73b2056b426423c638@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tungstentide@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, tungstentide@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <4DE59711.3090900@gmail.com>
References: <4DE59711.3090900@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Fixed an include coding style issue
Git-Commit-ID: bd38c0e6f98326132a691d73b2056b426423c638
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:50:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd38c0e6f98326132a691d73b2056b426423c638
Gitweb:     http://git.kernel.org/tip/bd38c0e6f98326132a691d73b2056b426423c638
Author:     Paul McQuade <tungstentide@gmail.com>
AuthorDate: Tue, 31 May 2011 20:51:55 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:45 -0400

ftrace: Fixed an include coding style issue

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
 
