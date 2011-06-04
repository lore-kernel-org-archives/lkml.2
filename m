Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1FDLG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 07:06:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:47964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab1FDLG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 07:06:56 -0400
Date: Sat, 4 Jun 2011 11:06:30 GMT
From: tip-bot for Vince Weaver <vweaver1@eecs.utk.edu>
Message-ID: <tip-d7ebe75b065a7c2d58ffc12f9d2e00d5ea4e71eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, vweaver1@eecs.utk.edu,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, vweaver1@eecs.utk.edu,
        mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1106031757090.29381@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106031757090.29381@cl320.eecs.utk.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix comments in include/linux/perf_event.h
Git-Commit-ID: d7ebe75b065a7c2d58ffc12f9d2e00d5ea4e71eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 04 Jun 2011 11:06:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7ebe75b065a7c2d58ffc12f9d2e00d5ea4e71eb
Gitweb:     http://git.kernel.org/tip/d7ebe75b065a7c2d58ffc12f9d2e00d5ea4e71eb
Author:     Vince Weaver <vweaver1@eecs.utk.edu>
AuthorDate: Fri, 3 Jun 2011 17:59:51 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jun 2011 12:31:14 +0200

perf: Fix comments in include/linux/perf_event.h

Fix include/linux/perf_event.h comments to be consistent with
the actual #define names. This is trivial, but it can be a bit
confusing when first  reading through the file.

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1106031757090.29381@cl320.eecs.utk.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..e0786e3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -137,14 +137,14 @@ enum perf_event_sample_format {
  *
  * struct read_format {
  *	{ u64		value;
- *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
- *	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ *	  { u64		time_enabled; } && PERF_FORMAT_TOTAL_TIME_ENABLED
+ *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		id;           } && PERF_FORMAT_ID
  *	} && !PERF_FORMAT_GROUP
  *
  *	{ u64		nr;
- *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
- *	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ *	  { u64		time_enabled; } && PERF_FORMAT_TOTAL_TIME_ENABLED
+ *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		value;
  *	    { u64	id;           } && PERF_FORMAT_ID
  *	  }		cntr[nr];
