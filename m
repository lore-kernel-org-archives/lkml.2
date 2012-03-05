Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2CEQXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:23:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60936 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2CEQXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:23:53 -0500
Date: Mon, 5 Mar 2012 08:23:02 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-824ac0e9838aadf5a398850c80ec2a43b9d0ca49@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1329986784-4916-5-git-send-email-namhyung.kim@lge.com>
References: <1329986784-4916-5-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix help string on tui
Git-Commit-ID: 824ac0e9838aadf5a398850c80ec2a43b9d0ca49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 08:23:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  824ac0e9838aadf5a398850c80ec2a43b9d0ca49
Gitweb:     http://git.kernel.org/tip/824ac0e9838aadf5a398850c80ec2a43b9d0ca49
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 23 Feb 2012 17:46:23 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Mar 2012 10:15:50 -0300

perf annotate: Fix help string on tui

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
 1 files changed, 3 insertions(+), 3 deletions(-)

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
