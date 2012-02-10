Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab2BJAzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:55:16 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48912 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824Ab2BJAzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:55:13 -0500
X-AuditID: 9c930179-b7cf1ae000000e40-dc-4f346aeba31a
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] perf tools: ctype.c only wants util.h
Date: Fri, 10 Feb 2012 10:10:16 +0900
Message-Id: <1328836217-9118-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1328836217-9118-1-git-send-email-namhyung.kim@lge.com>
References: <1328836217-9118-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of sane ctype macros only depends on symbols in
util.h not cache.h.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/ctype.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ctype.c b/tools/perf/util/ctype.c
index 35073621e5de..aada3ac5e891 100644
--- a/tools/perf/util/ctype.c
+++ b/tools/perf/util/ctype.c
@@ -3,7 +3,7 @@
  *
  * No surprises, and works with signed and unsigned chars.
  */
-#include "cache.h"
+#include "util.h"
 
 enum {
 	S = GIT_SPACE,
-- 
1.7.9

