Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032961Ab2CSUHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:07:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032835Ab2CSUHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:07:30 -0400
Date: Mon, 19 Mar 2012 13:07:07 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-fde0eeaba7fe18dfd2ee6142fb562123e510ef84@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1332125628-23088-1-git-send-email-namhyung.kim@lge.com>
References: <1332125628-23088-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Document --symbol-filter option
Git-Commit-ID: fde0eeaba7fe18dfd2ee6142fb562123e510ef84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 13:07:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fde0eeaba7fe18dfd2ee6142fb562123e510ef84
Gitweb:     http://git.kernel.org/tip/fde0eeaba7fe18dfd2ee6142fb562123e510ef84
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 19 Mar 2012 11:53:48 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 19 Mar 2012 12:13:56 -0300

perf report: Document --symbol-filter option

Add missing description of --symbol-filter in Documentation/perf-report.txt.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1332125628-23088-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 87feeee..68bbf9c 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -48,6 +48,9 @@ OPTIONS
 	Only consider these symbols. CSV that understands
 	file://filename entries.
 
+--symbol-filter=::
+	Only show symbols that match (partially) with this filter.
+
 -U::
 --hide-unresolved::
         Only display entries resolved to a symbol.
