Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1CTSy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 14:54:56 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:10794 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1CTSyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 14:54:51 -0400
X-IronPort-AV: E=Sophos;i="4.63,215,1299456000"; 
   d="scan'208";a="278221368"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 5/5] perf python: add REALTIME to constants
Date: Sun, 20 Mar 2011 12:54:37 -0600
Message-Id: <1300647277-8431-6-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300647277-8431-1-git-send-email-daahern@cisco.com>
References: <1300647277-8431-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/util/python.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a9f2d7e..a3e9183 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -827,6 +827,7 @@ static struct {
 	{ "SAMPLE_CALLCHAIN", PERF_SAMPLE_CALLCHAIN },
 	{ "SAMPLE_ID",	      PERF_SAMPLE_ID },
 	{ "SAMPLE_CPU",	      PERF_SAMPLE_CPU },
+	{ "SAMPLE_REALTIME",  PERF_SAMPLE_REALTIME },
 	{ "SAMPLE_PERIOD",    PERF_SAMPLE_PERIOD },
 	{ "SAMPLE_STREAM_ID", PERF_SAMPLE_STREAM_ID },
 	{ "SAMPLE_RAW",	      PERF_SAMPLE_RAW },
-- 
1.7.4

