Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009Ab2EJRWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:22:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:60472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab2EJRRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:17:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/16] perf annotate: shorten helpline so it fits in visible space
Date: Thu, 10 May 2012 14:17:44 -0300
Message-Id: <1336670265-20401-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336670265-20401-1-git-send-email-acme@infradead.org>
References: <1336670265-20401-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Additional toggles have pushed the help line out of view on a modestly
sized terminal (120 columns wide). Shorten it to just reminders.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1336510879-64610-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 4db5186..a299290 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -491,9 +491,9 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 	struct map_symbol *ms = self->b.priv;
 	struct symbol *sym = ms->sym;
 	const char *help = "<-/ESC: Exit, TAB/shift+TAB: Cycle hot lines, "
-			   "H: Go to hottest line, ->/ENTER: Line action, "
-			   "O: Toggle offset view, "
-			   "S: Toggle source code view";
+			   "H: Hottest line, ->/ENTER: Line action, "
+			   "O: Offset view, "
+			   "S: Source view";
 	int key;
 
 	if (ui_browser__show(&self->b, sym->name, help) < 0)
-- 
1.7.9.2.358.g22243

