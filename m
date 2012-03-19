Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab2CSCwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:52:53 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55235 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab2CSCww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:52:52 -0400
X-AuditID: 9c930179-b7b27ae000000e38-5e-4f669f8132d0
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf report: Document --symbol-filter option
Date: Mon, 19 Mar 2012 11:53:48 +0900
Message-Id: <1332125628-23088-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <20120316194244.GP9528@infradead.org>
References: <20120316194244.GP9528@infradead.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing description of --symbol-filter in Documentation/perf-report.txt.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/Documentation/perf-report.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 87feeee8b90c..68bbf9cec4b7 100644
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
-- 
1.7.9

