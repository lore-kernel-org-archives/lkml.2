Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab1FABeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:34:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52655 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192Ab1FABeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Fk51YLbDp6975xdMFPPE5k2M+7DtGUrF4sbCYvsMK9Ff0BYQg6+wPi2HPerx77ScQM
         scvN1P7jyYdauNMaJjzD3T0XHFeOBb+up2AI77Oo27xbfaeDI2Oh2W/jW0rsvWC4Bxai
         SjXd0OiASRAchez9AXjGcNa1VoALCjXf1nzgw=
Message-ID: <4DE59711.3090900@gmail.com>
Date: Wed, 01 Jun 2011 02:34:09 +0100
From: Paul McQuade <tungstentide@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: KERNEL: trace: ftrace: Fixed an include coding style issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2514174efe73e654c46e669ea2df5169a41d0130 Mon Sep 17 00:00:00 2001
From: Paul McQuade <tungstentide@gmail.com>
Date: Tue, 31 May 2011 20:51:55 +0100
Subject: KERNEL: trace: ftrace: Fixed an include coding style issue

ftrace:
Removed <asm/ftrace.h> because <linux/ftrace.h> was already declared.
Braces of struct's coding style fixed.

Signed-off-by: Paul McQuade <tungstentide@gmail.com>
---
 kernel/trace/ftrace.c |   12 ++++--------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ee417f..02c1cef 100644
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


@@ -2483,8 +2480,7 @@ function_trace_probe_call(unsigned long ip,
unsigned long parent_ip)
 	preempt_enable_notrace();
 }

-static struct ftrace_ops trace_probe_ops __read_mostly =
-{
+static struct ftrace_ops trace_probe_ops __read_mostly = {
 	.func		= function_trace_probe_call,
 };

-- 
1.7.4.1

