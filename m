Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab2C3Rj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:39:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:60124 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab2C3RjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:39:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="127050732"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf tools: fix build for rbtree.c change
Date: Fri, 30 Mar 2012 10:38:33 -0700
Message-Id: <1333129114-22117-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

rbtree.c in the main tree now includes linux/export.h, so this file
needs a stub too. This makes perf build again in mainline.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/include/linux/export.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/include/linux/export.h

diff --git a/tools/perf/util/include/linux/export.h b/tools/perf/util/include/linux/export.h
new file mode 100644
index 0000000..493b181
--- /dev/null
+++ b/tools/perf/util/include/linux/export.h
@@ -0,0 +1 @@
+#include <linux/module.h>
-- 
1.7.7.6

