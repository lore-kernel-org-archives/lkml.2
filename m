Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2EHVB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:01:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43873 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2EHVB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:01:26 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf annotate: shorten helpline so it fits in visible space
Date: Tue,  8 May 2012 15:01:19 -0600
Message-Id: <1336510879-64610-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional toggles have pushed the help line out of view on
a modestly sized terminal (120 columns wide). Shorten it
to just reminders.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/ui/browsers/annotate.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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
1.7.5.4

