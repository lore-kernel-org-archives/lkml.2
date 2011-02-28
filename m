Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1B1IXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 03:23:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:40002 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab1B1IXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 03:23:20 -0500
Date: Mon, 28 Feb 2011 08:22:46 GMT
From: tip-bot for Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, acme@ghostprotocols.net, trenn@suse.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, acme@ghostprotocols.net, tglx@linutronix.de,
        trenn@suse.de, mingo@elte.hu
In-Reply-To: <1298842606-55712-5-git-send-email-trenn@suse.de>
References: <1298842606-55712-5-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf timechart: Fix black idle boxes in the title
Message-ID: <tip-e853072055a01d8b3c4dc89d231649189454c4f1@git.kernel.org>
Git-Commit-ID: e853072055a01d8b3c4dc89d231649189454c4f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Feb 2011 08:22:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e853072055a01d8b3c4dc89d231649189454c4f1
Gitweb:     http://git.kernel.org/tip/e853072055a01d8b3c4dc89d231649189454c4f1
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Sun, 27 Feb 2011 22:36:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Feb 2011 08:56:14 +0100

perf timechart: Fix black idle boxes in the title

This fix is needed for eye of gnome and firefox svg viewers.
Only Inkscape can handle the broken case.

Compare with the other svg_legenda_box declarations, looks
like a typo slipped in at this place.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: lenb@kernel.org
LKML-Reference: <1298842606-55712-5-git-send-email-trenn@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/svghelper.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index fb737fe..96c8660 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -456,9 +456,9 @@ void svg_legenda(void)
 		return;
 
 	svg_legenda_box(0,	"Running", "sample");
-	svg_legenda_box(100,	"Idle","rect.c1");
-	svg_legenda_box(200,	"Deeper Idle", "rect.c3");
-	svg_legenda_box(350,	"Deepest Idle", "rect.c6");
+	svg_legenda_box(100,	"Idle","c1");
+	svg_legenda_box(200,	"Deeper Idle", "c3");
+	svg_legenda_box(350,	"Deepest Idle", "c6");
 	svg_legenda_box(550,	"Sleeping", "process2");
 	svg_legenda_box(650,	"Waiting for cpu", "waiting");
 	svg_legenda_box(800,	"Blocked on IO", "blocked");
