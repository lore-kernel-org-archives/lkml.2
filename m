Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2BWI2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:28:14 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59570 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2BWI1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:27:30 -0500
X-AuditID: 9c93016f-b7cc4ae0000027c5-e3-4f45f86e6d88
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] perf annotate: Fix help string on tui
Date: Thu, 23 Feb 2012 17:46:23 +0900
Message-Id: <1329986784-4916-5-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
References: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate multiple binding using /, capitalize descriptions,
add missing key binding.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/ui/browsers/annotate.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index e73357770d5d..57a4c6ef3fd2 100644
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
1.7.9

