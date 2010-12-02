Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0LBLoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:44:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:53582 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab0LBLoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:44:16 -0500
Date: Thu, 2 Dec 2010 11:43:55 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-5-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-5-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Document missing options
Message-ID: <tip-5ea4f857850450dc1442144a00547d6623d79d78@git.kernel.org>
Git-Commit-ID: 5ea4f857850450dc1442144a00547d6623d79d78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:43:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ea4f857850450dc1442144a00547d6623d79d78
Gitweb:     http://git.kernel.org/tip/5ea4f857850450dc1442144a00547d6623d79d78
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:12 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:46 -0200

perf diff: Document missing options

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
