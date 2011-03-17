Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1CQLFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:05:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:34482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab1CQLFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:05:08 -0400
Date: Thu, 17 Mar 2011 11:04:40 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, rientjes@google.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, rientjes@google.com,
        mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1103161716320.11407@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1103161716320.11407@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] trace, documentation: Fix branch profiling location in debugfs
Message-ID: <tip-13e5befaddcf8d542ae45610b552105490a0010b@git.kernel.org>
Git-Commit-ID: 13e5befaddcf8d542ae45610b552105490a0010b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Mar 2011 11:04:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13e5befaddcf8d542ae45610b552105490a0010b
Gitweb:     http://git.kernel.org/tip/13e5befaddcf8d542ae45610b552105490a0010b
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 16 Mar 2011 17:17:08 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Mar 2011 09:10:45 +0100

trace, documentation: Fix branch profiling location in debugfs

The debugfs interface for branch profiling is through

	/sys/kernel/debug/tracing/trace_stat/branch_annotated
	/sys/kernel/debug/tracing/trace_stat/branch_all

so update the Kconfig accordingly.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <alpine.DEB.2.00.1103161716320.11407@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 14674dc..61d7d59f 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -275,7 +275,7 @@ config PROFILE_ANNOTATED_BRANCHES
 	  This tracer profiles all the the likely and unlikely macros
 	  in the kernel. It will display the results in:
 
-	  /sys/kernel/debug/tracing/profile_annotated_branch
+	  /sys/kernel/debug/tracing/trace_stat/branch_annotated
 
 	  Note: this will add a significant overhead; only turn this
 	  on if you need to profile the system's use of these macros.
@@ -288,7 +288,7 @@ config PROFILE_ALL_BRANCHES
 	  taken in the kernel is recorded whether it hit or miss.
 	  The results will be displayed in:
 
-	  /sys/kernel/debug/tracing/profile_branch
+	  /sys/kernel/debug/tracing/trace_stat/branch_all
 
 	  This option also enables the likely/unlikely profiler.
 
