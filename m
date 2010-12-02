Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab0LBLoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:44:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:53595 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab0LBLoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:44:38 -0500
Date: Thu, 2 Dec 2010 11:44:16 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-6-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-6-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Document missing options
Message-ID: <tip-5c0ef0ab077c8bdb224540fea60473439be1bdb4@git.kernel.org>
Git-Commit-ID: 5c0ef0ab077c8bdb224540fea60473439be1bdb4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:44:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c0ef0ab077c8bdb224540fea60473439be1bdb4
Gitweb:     http://git.kernel.org/tip/5c0ef0ab077c8bdb224540fea60473439be1bdb4
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:13 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:46 -0200

perf kvm: Document missing options

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
