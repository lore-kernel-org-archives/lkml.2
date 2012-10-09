Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab2JIRgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:36:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab2JIRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:36:52 -0400
Date: Tue, 9 Oct 2012 10:36:29 -0700
From: tip-bot for Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Message-ID: <tip-ae86912f48b624540b886187e169bcf47a14e42a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, yongjun_wei@trendmicro.com.cn,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        yongjun_wei@trendmicro.com.cn, tglx@linutronix.de
In-Reply-To: <CAPgLHd8fz+TznMVRdhzPb45WtZQXhVxadRQcLxUC4O9aX+SUbA@mail.gmail.com>
References: <CAPgLHd8fz+TznMVRdhzPb45WtZQXhVxadRQcLxUC4O9aX+SUbA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove duplicated include from trace-event-python.c
Git-Commit-ID: ae86912f48b624540b886187e169bcf47a14e42a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:36:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae86912f48b624540b886187e169bcf47a14e42a
Gitweb:     http://git.kernel.org/tip/ae86912f48b624540b886187e169bcf47a14e42a
Author:     Wei Yongjun <yongjun_wei@trendmicro.com.cn>
AuthorDate: Sun, 7 Oct 2012 22:09:12 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 7 Oct 2012 13:15:04 -0300

perf tools: Remove duplicated include from trace-event-python.c

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Link: http://lkml.kernel.org/r/CAPgLHd8fz+TznMVRdhzPb45WtZQXhVxadRQcLxUC4O9aX+SUbA@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../util/scripting-engines/trace-event-python.c    |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 730c663..14683df 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -32,7 +32,6 @@
 #include "../event.h"
 #include "../thread.h"
 #include "../trace-event.h"
-#include "../evsel.h"
 
 PyMODINIT_FUNC initperf_trace_context(void);
 
