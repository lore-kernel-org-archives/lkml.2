Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2IFCSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 22:18:16 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44671 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab2IFCSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 22:18:15 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-9f-504807e501f0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/2] perf header: Fix a typo on evsel
Date: Thu,  6 Sep 2012 11:10:45 +0900
Message-Id: <1346897446-16569-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For checking return value of the strdup, 'event' should be 'evsel'.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 06ecd577d1b8..eb7a8da2f4f5 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2512,7 +2512,7 @@ static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel,
 
 	snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
 	evsel->name = strdup(bf);
-	if (event->name == NULL)
+	if (evsel->name == NULL)
 		return -1;
 
 	evsel->tp_format = event;
-- 
1.7.11.4

