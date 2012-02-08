Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab2BHKF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:05:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61138 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2BHKFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:05:54 -0500
From: Geunsik Lim <geunsik.lim@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: Append wakeup_rt description of ftrace doc
Date: Wed,  8 Feb 2012 19:05:37 +0900
Message-Id: <1328695537-15081-2-git-send-email-geunsik.lim@gmail.com>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1328695537-15081-1-git-send-email-geunsik.lim@gmail.com>
References: <1328695537-15081-1-git-send-email-geunsik.lim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

Append and update the description about wakeup/wakeup_rt usage.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 Documentation/trace/ftrace.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 1ebc24c..03b5205 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -226,6 +226,13 @@ Here is the list of current tracers that may be configured.
 	Traces and records the max latency that it takes for
 	the highest priority task to get scheduled after
 	it has been woken up.
+        Traces all tasks as an average developer would expect.
+
+  "wakeup_rt"
+
+        Traces and records the max latency that it takes for just
+        RT tasks (as the current "wakeup" does). This is useful
+        for those interested in wake up timings of RT tasks.
 
   "hw-branch-tracer"
 
-- 
1.7.8.1

