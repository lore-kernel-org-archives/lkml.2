Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636Ab2EKGts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:49:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760560Ab2EKGtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:49:46 -0400
Date: Thu, 10 May 2012 23:49:36 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-f6c1be2711333b40d7940ff87e3509b4cd278195@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1336510879-64610-1-git-send-email-dsahern@gmail.com>
References: <1336510879-64610-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  shorten helpline so it fits in visible space
Git-Commit-ID: f6c1be2711333b40d7940ff87e3509b4cd278195
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:49:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6c1be2711333b40d7940ff87e3509b4cd278195
Gitweb:     http://git.kernel.org/tip/f6c1be2711333b40d7940ff87e3509b4cd278195
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 8 May 2012 15:01:19 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 May 2012 12:02:36 -0300

perf annotate: shorten helpline so it fits in visible space

Additional toggles have pushed the help line out of view on a modestly
sized terminal (120 columns wide). Shorten it to just reminders.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1336510879-64610-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
