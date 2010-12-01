Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0LASEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:04:39 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58860 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab0LASBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:01:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/15] perf annotate: Document missing options.
Date: Wed,  1 Dec 2010 16:00:51 -0200
Message-Id: <1291226465-26337-2-git-send-email-acme@infradead.org>
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
LKML-Reference: <1291168642-11402-2-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |   37 +++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index b2c6330..6f5a498 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -24,12 +24,47 @@ OPTIONS
 --input=::
         Input file name. (default: perf.data)
 
+-d::
+--dsos=<dso[,dso...]>::
+        Only consider symbols in these dsos.
+-s::
+--symbol=<symbol>::
+        Symbol to annotate.
+
+-f::
+--force::
+        Don't complain, do it.
+
+-v::
+--verbose::
+        Be more verbose. (Show symbol address, etc)
+
+-D::
+--dump-raw-trace::
+        Dump raw trace in ASCII.
+
+-k::
+--vmlinux=<file>::
+        vmlinux pathname.
+
+-m::
+--modules::
+        Load module symbols. WARNING: use only with -k and LIVE kernel.
+
+-l::
+--print-line::
+        Print matching source lines (may be slow).
+
+-P::
+--full-paths::
+        Don't shorten the displayed pathnames.
+
 --stdio:: Use the stdio interface.
 
 --tui:: Use the TUI interface Use of --tui requires a tty, if one is not
 	present, as when piping to other commands, the stdio interface is
 	used. This interfaces starts by centering on the line with more
-	samples, TAB/UNTAB cycles thru the lines with more samples.
+	samples, TAB/UNTAB cycles through the lines with more samples.
 
 SEE ALSO
 --------
-- 
1.6.2.5

