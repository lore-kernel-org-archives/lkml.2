Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2JRX3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:29:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:28177 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab2JRXTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:19:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,609,1344236400"; 
   d="scan'208";a="206293154"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/34] perf, tools: Add abort,notx,intx branch filter options to perf report -j
Date: Thu, 18 Oct 2012 16:19:19 -0700
Message-Id: <1350602382-12771-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Make perf report -j aware of the new intx,notx,abort branch qualifiers.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-record.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e9231659..aa9e452 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -725,6 +725,9 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
 	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
 	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
+	BRANCH_OPT("abort", PERF_SAMPLE_BRANCH_ABORT),
+	BRANCH_OPT("intx", PERF_SAMPLE_BRANCH_INTX),
+	BRANCH_OPT("notx", PERF_SAMPLE_BRANCH_NOTX),
 	BRANCH_END
 };
 
-- 
1.7.7.6

