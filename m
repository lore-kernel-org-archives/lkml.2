Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab0LBLrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:47:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:60965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab0LBLrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:47:09 -0500
Date: Thu, 2 Dec 2010 11:46:41 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-15-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-15-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Document missing options
Message-ID: <tip-646420f1bcf6ddf3e150f92a5f2a8bd7d6057ff8@git.kernel.org>
Git-Commit-ID: 646420f1bcf6ddf3e150f92a5f2a8bd7d6057ff8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:46:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  646420f1bcf6ddf3e150f92a5f2a8bd7d6057ff8
Gitweb:     http://git.kernel.org/tip/646420f1bcf6ddf3e150f92a5f2a8bd7d6057ff8
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:22 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:48 -0200

perf trace: Document missing options

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-15-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 26aff6b..1c61ea9 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -104,6 +104,13 @@ OPTIONS
         normally don't - this option allows the latter to be run in
         system-wide mode.
 
+-i::
+--input=::
+        Input file name.
+
+-d::
+--debug-mode::
+        Do various checks like samples ordering and lost events.
 
 SEE ALSO
 --------
