Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0HBHuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:50:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:60237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab0HBHuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:50:12 -0400
Date: Mon, 2 Aug 2010 07:49:31 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Restore SPACE as an alias to PGDN in annotate
Message-ID: <tip-b61b55ed995fd2765cd4ec0b22f0348dee272070@git.kernel.org>
Git-Commit-ID: b61b55ed995fd2765cd4ec0b22f0348dee272070
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:49:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b61b55ed995fd2765cd4ec0b22f0348dee272070
Gitweb:     http://git.kernel.org/tip/b61b55ed995fd2765cd4ec0b22f0348dee272070
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 21 Jul 2010 17:55:32 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 27 Jul 2010 11:24:31 -0300

perf ui: Restore SPACE as an alias to PGDN in annotate

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index ab6eb36..2f5f7a1 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -750,6 +750,7 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 
 	browser.width += 18; /* Percentage */
 	ui_browser__show(&browser, self->ms.sym->name);
+	newtFormAddHotKey(browser.form, ' ');
 	ret = ui_browser__run(&browser, &es);
 	newtFormDestroy(browser.form);
 	newtPopWindow();
