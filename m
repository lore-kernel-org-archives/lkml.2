Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2AYOGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:06:15 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37367
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753412Ab2AYOGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:06:14 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Cc: standby24x7@gmail.com, trivial@kernel.org
Subject: [PATCH] [trivial] perf: Fix typo in evsel.c
Date: Wed, 25 Jan 2012 23:05:12 +0900
Message-Id: <1327500312-9520-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "unsuported" to "unsupported" in
tools/peft/util/evsel.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
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
1.7.6.5

