Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0LAB6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:58:30 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56724 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0LAB62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wGHTfl2MFrSIWVW8kysvekDkw0fVVlJ4jhjgJbgTzNfgxGuBA3E9syLLwQAWP5Z9gF
         QH/5KRpRZadNUSchxA4+Nv2NKbhyavU6JkADnG/4ax9HoCYnZ2L7utPl/cCMJ43YJkjC
         XeHt/GotUlEODXbtO/o/anAGgfQlVxz6DJ83w=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 01/14] perf: Document missing annotate options.
Date: Tue, 30 Nov 2010 19:57:09 -0600
Message-Id: <1291168642-11402-2-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
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
1.7.3.2

