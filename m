Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2KIR2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:28:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab2KIR2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:28:42 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/13] perf annotate: Whitespace fixups
Date: Sat, 10 Nov 2012 02:27:13 +0900
Message-Id: <1352482044-3443-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some lines are indented by whitespace characters rather than tabs.
Fix them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 0565558b6184..12287b121669 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -175,14 +175,14 @@ static int lock__parse(struct ins_operands *ops)
 		goto out_free_ops;
 
 	ops->locked.ins = ins__find(name);
-        if (ops->locked.ins == NULL)
-                goto out_free_ops;
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
 
-- 
1.7.9.2

