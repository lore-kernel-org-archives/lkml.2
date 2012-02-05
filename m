Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2BEIQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 03:16:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab2BEIP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 03:15:58 -0500
Date: Sun, 5 Feb 2012 16:15:50 +0800
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, xiyou.wangcong@gmail.com, penberg@kernel.org,
        fengguang.wu@intel.com, cl@linux.com
Subject: [PATCH 2/3] move slabinfo.c to tools/vm
Message-ID: <20120205081550.GA2247@darkstar.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have tools/vm/ folder for vm tools, so move slabinfo.c
from tools/slub/ to tools/vm/

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 tools/vm/Makefile             |    4 ++--
 tools/{slub => vm}/slabinfo.c |    0
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/{slub => vm}/slabinfo.c (100%)

diff --git a/tools/vm/Makefile b/tools/vm/Makefile
index 3823d4b..8e30e5c 100644
--- a/tools/vm/Makefile
+++ b/tools/vm/Makefile
@@ -3,9 +3,9 @@
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra
 
-all: page-types
+all: page-types slabinfo
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^
 
 clean:
-	$(RM) page-types
+	$(RM) page-types slabinfo
diff --git a/tools/slub/slabinfo.c b/tools/vm/slabinfo.c
similarity index 100%
rename from tools/slub/slabinfo.c
rename to tools/vm/slabinfo.c
-- 
1.7.4.4

