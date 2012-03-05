Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2CEP4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:56:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:53821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2CEPzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:55:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/7] perf annotate: Fix help string on tui
Date: Mon,  5 Mar 2012 12:55:31 -0300
Message-Id: <1330962932-1796-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1330962932-1796-1-git-send-email-acme@infradead.org>
References: <1330962932-1796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Separate multiple binding using /, capitalize descriptions, add missing
key binding.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1329986784-4916-5-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index e733577..57a4c6e 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -233,9 +233,9 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 	struct rb_node *nd = NULL;
 	struct map_symbol *ms = self->b.priv;
 	struct symbol *sym = ms->sym;
-	const char *help = "<-, ESC: exit, TAB/shift+TAB: cycle hottest lines, "
-			   "H: Hottest, -> Line action, S -> Toggle source "
-			   "code view";
+	const char *help = "<-/ESC: Exit, TAB/shift+TAB: Cycle hot lines, "
+			   "H: Go to hottest line, ->/ENTER: Line action, "
+			   "S: Toggle source code view";
 	int key;
 
 	if (ui_browser__show(&self->b, sym->name, help) < 0)
-- 
1.7.9.2.358.g22243

