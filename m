Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1G1Xof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:8198 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab1G1XoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="35732396"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: andi@firstfloor.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [10/50] Drop -Werror in perf
Message-Id: <20110728234414.79DED2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andi Kleen <andi@firstfloor.org>

Drop -Werror in perf Makefile. This fixes the build with gcc 4.5.x

Not in mainline.
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/tools/perf/Makefile
===================================================================
--- linux-2.6.35.y.orig/tools/perf/Makefile
+++ linux-2.6.35.y/tools/perf/Makefile
@@ -225,7 +225,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
