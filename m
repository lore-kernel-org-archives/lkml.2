Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab0DHOjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:39:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:41489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0DHOjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:39:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/6] perf TUI: Move "Yes" button to before "No"
Date: Thu,  8 Apr 2010 11:38:45 -0300
Message-Id: <1270737529-24258-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270737529-24258-1-git-send-email-acme@infradead.org>
References: <1270737529-24258-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Esc + Enter should be enough warning to avoid accidentaly exiting from
the browser.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index c0e71aa..7a123a9 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -132,7 +132,7 @@ static bool dialog_yesno(const char *msg)
 {
 	/* newtWinChoice should really be accepting const char pointers... */
 	char yes[] = "Yes", no[] = "No";
-	return newtWinChoice(NULL, no, yes, (char *)msg) == 2;
+	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
 }
 
 /*
-- 
1.6.2.5

