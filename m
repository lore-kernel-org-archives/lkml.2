Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1JRVpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:45:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43285 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab1JRVoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:44:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/7] perf hists browser: Add missing hotkeys to the help window
Date: Tue, 18 Oct 2011 19:44:01 -0200
Message-Id: <1318974247-6683-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318974247-6683-1-git-send-email-acme@infradead.org>
References: <1318974247-6683-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The navigation keys were missing (UP, DOWN arrows, etc).

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3pnln0bws5v0yoqwd3f020nx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index b144b10..873b852 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -886,17 +886,20 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		case NEWT_KEY_F1:
 		case 'h':
 		case '?':
-			ui__help_window("h/?/F1    Show this window\n"
-					"TAB/UNTAB Switch events\n"
-					"q/CTRL+C  Exit browser\n\n"
+			ui__help_window("h/?/F1        Show this window\n"
+					"UP/DOWN/PGUP\n"
+					"PGDN/SPACE    Navigate\n"
+					"q/ESC/CTRL+C  Exit browser\n\n"
+					"For multiple event sessions:\n\n"
+					"TAB/UNTAB Switch events\n\n"
 					"For symbolic views (--sort has sym):\n\n"
-					"->        Zoom into DSO/Threads & Annotate current symbol\n"
-					"<-        Zoom out\n"
-					"a         Annotate current symbol\n"
-					"C         Collapse all callchains\n"
-					"E         Expand all callchains\n"
-					"d         Zoom into current DSO\n"
-					"t         Zoom into current Thread\n");
+					"->            Zoom into DSO/Threads & Annotate current symbol\n"
+					"<-            Zoom out\n"
+					"a             Annotate current symbol\n"
+					"C             Collapse all callchains\n"
+					"E             Expand all callchains\n"
+					"d             Zoom into current DSO\n"
+					"t             Zoom into current Thread\n");
 			continue;
 		case NEWT_KEY_ENTER:
 		case NEWT_KEY_RIGHT:
-- 
1.6.2.5

