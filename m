Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab2CVVVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:21:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab2CVVVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:21:21 -0400
Date: Thu, 22 Mar 2012 14:21:06 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-37d73998920859784e6504462a2fd5f52cc08051@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de
In-Reply-To: <20120313230302.GA1514@m.redhat.com>
References: <20120313230302.GA1514@m.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Add ifdef to remove unused enum switch warnings
Git-Commit-ID: 37d73998920859784e6504462a2fd5f52cc08051
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 22 Mar 2012 14:21:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37d73998920859784e6504462a2fd5f52cc08051
Gitweb:     http://git.kernel.org/tip/37d73998920859784e6504462a2fd5f52cc08051
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 14 Mar 2012 00:03:02 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 14 Mar 2012 08:47:58 -0400

perf: Add ifdef to remove unused enum switch warnings

Fix for unused symbols in switch warnings.

Link: http://lkml.kernel.org/r/20120313230302.GA1514@m.redhat.com

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index dd478fc..5f3f3be 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -144,12 +144,14 @@ struct event_filter;
 enum trace_reg {
 	TRACE_REG_REGISTER,
 	TRACE_REG_UNREGISTER,
+#ifdef CONFIG_PERF_EVENTS
 	TRACE_REG_PERF_REGISTER,
 	TRACE_REG_PERF_UNREGISTER,
 	TRACE_REG_PERF_OPEN,
 	TRACE_REG_PERF_CLOSE,
 	TRACE_REG_PERF_ADD,
 	TRACE_REG_PERF_DEL,
+#endif
 };
 
 struct ftrace_event_call;
