Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2KNHm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:42:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab2KNHm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:42:26 -0500
Date: Tue, 13 Nov 2012 23:42:09 -0800
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-2ba34aaa6db8b61cf1fa14132f885ba6bc7c9ae0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1352482044-3443-3-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Whitespace fixups
Git-Commit-ID: 2ba34aaa6db8b61cf1fa14132f885ba6bc7c9ae0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:42:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ba34aaa6db8b61cf1fa14132f885ba6bc7c9ae0
Gitweb:     http://git.kernel.org/tip/2ba34aaa6db8b61cf1fa14132f885ba6bc7c9ae0
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Sat, 10 Nov 2012 02:27:13 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 9 Nov 2012 16:22:46 -0300

perf annotate: Whitespace fixups

Some lines are indented by whitespace characters rather than tabs.  Fix
them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1352482044-3443-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index b14d4df..435bf6d 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -171,15 +171,15 @@ static int lock__parse(struct ins_operands *ops)
 	if (disasm_line__parse(ops->raw, &name, &ops->locked.ops->raw) < 0)
 		goto out_free_ops;
 
-        ops->locked.ins = ins__find(name);
-        if (ops->locked.ins == NULL)
-                goto out_free_ops;
+	ops->locked.ins = ins__find(name);
+	if (ops->locked.ins == NULL)
+		goto out_free_ops;
 
-        if (!ops->locked.ins->ops)
-                return 0;
+	if (!ops->locked.ins->ops)
+		return 0;
 
-        if (ops->locked.ins->ops->parse)
-                ops->locked.ins->ops->parse(ops->locked.ops);
+	if (ops->locked.ins->ops->parse)
+		ops->locked.ins->ops->parse(ops->locked.ops);
 
 	return 0;
 
