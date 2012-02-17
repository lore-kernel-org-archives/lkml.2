Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2BQNvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:51:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40160 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2BQNvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:51:31 -0500
Date: Fri, 17 Feb 2012 05:50:51 -0800
From: tip-bot for Geunsik Lim <geunsik.lim@samsung.com>
Message-ID: <tip-cdfb0d30e943f36c8a074a26c3d168a05bdbb372@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, geunsik.lim@samsung.com, rdunlap@xenotime.net,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        geunsik.lim@samsung.com, rostedt@goodmis.org, tglx@linutronix.de,
        rdunlap@xenotime.net
In-Reply-To: <1328695537-15081-2-git-send-email-geunsik.lim@gmail.com>
References: <1328695537-15081-2-git-send-email-geunsik.lim@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Append wakeup_rt description of ftrace doc
Git-Commit-ID: cdfb0d30e943f36c8a074a26c3d168a05bdbb372
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 05:51:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdfb0d30e943f36c8a074a26c3d168a05bdbb372
Gitweb:     http://git.kernel.org/tip/cdfb0d30e943f36c8a074a26c3d168a05bdbb372
Author:     Geunsik Lim <geunsik.lim@samsung.com>
AuthorDate: Wed, 8 Feb 2012 19:05:37 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 13 Feb 2012 09:14:48 -0500

ftrace: Append wakeup_rt description of ftrace doc

Append and update the description about wakeup/wakeup_rt usage.

Link: http://lkml.kernel.org/r/1328695537-15081-2-git-send-email-geunsik.lim@gmail.com

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 1ebc24c..6f51fed 100644
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
 
