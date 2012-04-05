Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab2DEQ10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:27:26 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:8439 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755216Ab2DEQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:26:39 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20LO9-01-4MV-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/4] perf tools: Fix thread map that is type pid_t
Date: Thu, 5 Apr 2012 18:26:26 +0200
Message-ID: <1333643188-26895-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
References: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thread map is actually type pid_t and not int.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/thread_map.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index 7da80f1..f718df8 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -6,7 +6,7 @@
 
 struct thread_map {
 	int nr;
-	int map[];
+	pid_t map[];
 };
 
 struct thread_map *thread_map__new_by_pid(pid_t pid);
-- 
1.7.8.4


