Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1JDKnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:43:00 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37072 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab1JDKm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:42:58 -0400
X-AuditID: b753bd60-a46b0ba0000019f4-01-4e8ae32f8984
X-AuditID: b753bd60-a46b0ba0000019f4-01-4e8ae32f8984
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 3/4] [TRIVIAL] perftools: Fix a typo of command name as
 trace-cmd
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 04 Oct 2011 19:44:56 +0900
Message-ID: <20111004104456.14591.37395.stgit@fedora15>
In-Reply-To: <20111004104438.14591.6553.stgit@fedora15>
References: <20111004104438.14591.6553.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo which may be introduced when original
code has been copied from trace-cmd.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 tools/perf/util/trace-event-info.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 3403f81..2ed5ab8 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -80,7 +80,7 @@ static void die(const char *fmt, ...)
 	int ret = errno;
 
 	if (errno)
-		perror("trace-cmd");
+		perror("perf");
 	else
 		ret = -1;
 

