Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511Ab2IHCKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:10:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:46405 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760173Ab2IHCH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:07:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/13] perf tools: Ignore compiled python binaries
Date: Fri,  7 Sep 2012 23:07:00 -0300
Message-Id: <1347070032-4161-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347070032-4161-1-git-send-email-acme@infradead.org>
References: <1347070032-4161-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It prevents mindless git add from adding those files.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346982953-30824-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 26b823b..8f8fbc2 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -21,3 +21,5 @@ config.mak
 config.mak.autogen
 *-bison.*
 *-flex.*
+*.pyc
+*.pyo
-- 
1.7.9.2.358.g22243

