Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0LBLn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:43:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:53507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0LBLnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:43:25 -0500
Date: Thu, 2 Dec 2010 11:42:48 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-2-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-2-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Document missing options.
Message-ID: <tip-1968ad911d0769e58a484bb721d275814baf9f2f@git.kernel.org>
Git-Commit-ID: 1968ad911d0769e58a484bb721d275814baf9f2f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:42:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1968ad911d0769e58a484bb721d275814baf9f2f
Gitweb:     http://git.kernel.org/tip/1968ad911d0769e58a484bb721d275814baf9f2f
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:09 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:45 -0200

perf annotate: Document missing options.

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
