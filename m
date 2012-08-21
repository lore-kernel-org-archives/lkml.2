Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab2HUPSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:18:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59557 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2HUPSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:18:14 -0400
Date: Tue, 21 Aug 2012 08:18:00 -0700
From: tip-bot for Wang Tianhong <wangthbj@linux.vnet.ibm.com>
Message-ID: <tip-87abb3b15c62033409f5bf2ffb5620c94f91cf2c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, wangthbj@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, wangthbj@linux.vnet.ibm.com
In-Reply-To: <1343887320.2228.9.camel@louis-ThinkPad-T410>
References: <1343887320.2228.9.camel@louis-ThinkPad-T410>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/trivial: Fix some typos in kernel/trace
Git-Commit-ID: 87abb3b15c62033409f5bf2ffb5620c94f91cf2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:18:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87abb3b15c62033409f5bf2ffb5620c94f91cf2c
Gitweb:     http://git.kernel.org/tip/87abb3b15c62033409f5bf2ffb5620c94f91cf2c
Author:     Wang Tianhong <wangthbj@linux.vnet.ibm.com>
AuthorDate: Thu, 2 Aug 2012 14:02:00 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 7 Aug 2012 09:43:32 -0400

tracing/trivial: Fix some typos in kernel/trace

Fix some typos in kernel/trace.

Link: http://lkml.kernel.org/r/1343887320.2228.9.camel@louis-ThinkPad-T410

Signed-off-by: Wang Tianhong <wangthbj@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    4 ++--
 kernel/trace/trace.c       |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 49491fa..b32ed0e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2816,7 +2816,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_enable);
  * to the buffer after this will fail and return NULL.
  *
  * This is different than ring_buffer_record_disable() as
- * it works like an on/off switch, where as the disable() verison
+ * it works like an on/off switch, where as the disable() version
  * must be paired with a enable().
  */
 void ring_buffer_record_off(struct ring_buffer *buffer)
@@ -2839,7 +2839,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_off);
  * ring_buffer_record_off().
  *
  * This is different than ring_buffer_record_enable() as
- * it works like an on/off switch, where as the enable() verison
+ * it works like an on/off switch, where as the enable() version
  * must be paired with a disable().
  */
 void ring_buffer_record_on(struct ring_buffer *buffer)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a120f98..d1a8d07 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -426,15 +426,15 @@ __setup("trace_buf_size=", set_buf_size);
 
 static int __init set_tracing_thresh(char *str)
 {
-	unsigned long threshhold;
+	unsigned long threshold;
 	int ret;
 
 	if (!str)
 		return 0;
-	ret = strict_strtoul(str, 0, &threshhold);
+	ret = strict_strtoul(str, 0, &threshold);
 	if (ret < 0)
 		return 0;
-	tracing_thresh = threshhold * 1000;
+	tracing_thresh = threshold * 1000;
 	return 1;
 }
 __setup("tracing_thresh=", set_tracing_thresh);
