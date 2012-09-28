Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2I1EcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:32:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:39591 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab2I1EcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:32:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="215093241"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 30/31] perf, tools: Point --sort documentation to --help
Date: Thu, 27 Sep 2012 21:31:35 -0700
Message-Id: <1348806696-31170-31-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The --sort documentation for top and report was hopelessly out-of-date
Instead of having two more places that would need to be updated,
just point to --help.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |    2 +-
 tools/perf/Documentation/perf-top.txt    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 495210a..b4e747a 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -57,7 +57,7 @@ OPTIONS
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
+	Sort by key(s): See --help for a full list.
 
 -p::
 --parent=<regex>::
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 5b80d84..0f0fa3e 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -112,7 +112,7 @@ Default is to monitor all CPUS.
 
 -s::
 --sort::
-	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
+	Sort by key(s): see --help for a full list.
 
 -n::
 --show-nr-samples::
-- 
1.7.7.6

