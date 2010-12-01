Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0LASBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:01:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:52294 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab0LASBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:01:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/15] perf kvm: Document missing options
Date: Wed,  1 Dec 2010 16:00:55 -0200
Message-Id: <1291226465-26337-6-git-send-email-acme@infradead.org>
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
LKML-Reference: <1291168642-11402-6-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-kvm.txt |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index d004e19..dd84cb2 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -22,7 +22,7 @@ There are a couple of variants of perf kvm:
   a performance counter profile of guest os in realtime
   of an arbitrary workload.
 
-  'perf kvm record <command>' to record the performance couinter profile
+  'perf kvm record <command>' to record the performance counter profile
   of an arbitrary workload and save it into a perf data file. If both
   --host and --guest are input, the perf data file name is perf.data.kvm.
   If there is  no --host but --guest, the file name is perf.data.guest.
@@ -40,6 +40,12 @@ There are a couple of variants of perf kvm:
 
 OPTIONS
 -------
+-i::
+--input=::
+        Input file name.
+-o::
+--output::
+        Output file name.
 --host=::
         Collect host side performance profile.
 --guest=::
-- 
1.6.2.5

