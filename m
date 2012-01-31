Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2AaBYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:24:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54861 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2AaBYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:24:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, trivial@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/9] perf evsel: Fix spelling typo
Date: Mon, 30 Jan 2012 23:24:31 -0200
Message-Id: <1327973079-29426-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327973079-29426-1-git-send-email-acme@infradead.org>
References: <1327973079-29426-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>

Correct spelling "unsuported" to "unsupported" in
tools/peft/util/evsel.c

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: standby24x7@gmail.com
Cc: trivial@kernel.org
Link: http://lkml.kernel.org/r/1327500312-9520-1-git-send-email-standby24x7@gmail.com
Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 667f3b7..dcfefab 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -535,7 +535,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_READ) {
-		fprintf(stderr, "PERF_SAMPLE_READ is unsuported for now\n");
+		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
 		return -1;
 	}
 
-- 
1.7.9.rc2.1.g69204

