Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0LASDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:03:49 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58861 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab0LASBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:01:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/15] perf diff: Document missing options
Date: Wed,  1 Dec 2010 16:00:54 -0200
Message-Id: <1291226465-26337-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291226465-26337-1-git-send-email-acme@infradead.org>
References: <1291226465-26337-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Bohrer <shawn.bohrer@gmail.com>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-5-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 20d97d8..6a9ec2b 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -19,6 +19,18 @@ If no parameters are passed it will assume perf.data.old and perf.data.
 
 OPTIONS
 -------
+-M::
+--displacement::
+        Show position displacement relative to baseline.
+
+-D::
+--dump-raw-trace::
+        Dump raw trace in ASCII.
+
+-m::
+--modules::
+        Load module symbols. WARNING: use only with -k and LIVE kernel
+
 -d::
 --dsos=::
 	Only consider symbols in these dsos. CSV that understands
@@ -42,7 +54,7 @@ OPTIONS
 --field-separator=::
 
 	Use a special separator character and don't pad with spaces, replacing
-	all occurances of this separator in symbol names (and other output)
+	all occurrences of this separator in symbol names (and other output)
 	with a '.' character, that thus it's the only non valid separator.
 
 -v::
@@ -50,6 +62,11 @@ OPTIONS
 	Be verbose, for instance, show the raw counts in addition to the
 	diff.
 
+-f::
+--force::
+       Don't complain, do it.
+
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
-- 
1.6.2.5

