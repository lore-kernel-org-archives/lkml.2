Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab2IFTbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:31:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40928 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463Ab2IFTbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:31:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/8] perf header: Fix a typo on evsel
Date: Thu,  6 Sep 2012 16:31:15 -0300
Message-Id: <1346959881-22427-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346959881-22427-1-git-send-email-acme@infradead.org>
References: <1346959881-22427-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For checking return value of the strdup, 'event' should be 'evsel'.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346897446-16569-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 43425b7..8b0b873 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2307,7 +2307,7 @@ static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel,
 
 	snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
 	evsel->name = strdup(bf);
-	if (event->name == NULL)
+	if (evsel->name == NULL)
 		return -1;
 
 	evsel->tp_format = event;
-- 
1.7.9.2.358.g22243

