Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1D2Idt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:33:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:22408 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab1D2IdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,286,1301900400"; 
   d="scan'208";a="685836911"
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] perf annotate: Remove duplicate header file
Date: Fri, 29 Apr 2011 08:41:58 +0000
Message-Id: <1304066518-30420-3-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304066518-30420-1-git-send-email-ming.m.lin@intel.com>
References: <1304066518-30420-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

annotate.h was included twice, remove one.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/util/ui/browsers/annotate.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 15633d6..4bb69e8 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -1,7 +1,6 @@
 #include "../browser.h"
 #include "../helpline.h"
 #include "../libslang.h"
-#include "../../annotate.h"
 #include "../../hist.h"
 #include "../../sort.h"
 #include "../../symbol.h"
-- 
1.7.4.4

