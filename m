Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0LASBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:01:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:52309 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0LASBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:01:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/15] perf buildid-list: Document missing options
Date: Wed,  1 Dec 2010 16:00:52 -0200
Message-Id: <1291226465-26337-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291226465-26337-1-git-send-email-acme@infradead.org>
References: <1291226465-26337-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Bohrer <shawn.bohrer@gmail.com>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-3-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-list.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-buildid-list.txt b/tools/perf/Documentation/perf-buildid-list.txt
index 01b642c..5eaac6f 100644
--- a/tools/perf/Documentation/perf-buildid-list.txt
+++ b/tools/perf/Documentation/perf-buildid-list.txt
@@ -18,6 +18,9 @@ perf report.
 
 OPTIONS
 -------
+-H::
+--with-hits::
+        Show only DSOs with hits.
 -i::
 --input=::
         Input file name. (default: perf.data)
-- 
1.6.2.5

