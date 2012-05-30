Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2E3RSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:18:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:49501 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2E3RSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:18:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf annotate browser: Fix help window entry for navigating to hottest line
Date: Wed, 30 May 2012 14:18:40 -0300
Message-Id: <1338398321-28327-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338398321-28327-1-git-send-email-acme@infradead.org>
References: <1338398321-28327-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Its 'H', not 'h'. The later is for getting to the help window.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-7zvwphhm815y2zczoxgstzuf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 4deea6a..34b1c46 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -668,7 +668,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 		"q/ESC/CTRL+C  Exit\n\n"
 		"->            Go to target\n"
 		"<-            Exit\n"
-		"h             Cycle thru hottest instructions\n"
+		"H             Cycle thru hottest instructions\n"
 		"j             Toggle showing jump to target arrows\n"
 		"J             Toggle showing number of jump sources on targets\n"
 		"n             Search next string\n"
-- 
1.7.9.2.358.g22243

