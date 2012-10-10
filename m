Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2JJB0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:26:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60565 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab2JJB0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:26:40 -0400
Date: Tue, 9 Oct 2012 18:26:36 -0700
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: fix duplicate header inclusion
Message-ID: <20121010012636.GA19749@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#include <stdbool.h> somehow got duplicated on its way to linus's tree
(probably as a conflict resolution as things got sent through multiple trees)

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 tools/perf/util/include/linux/rbtree.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
index 9bcdc844b330..2a030c5af3aa 100644
--- a/tools/perf/util/include/linux/rbtree.h
+++ b/tools/perf/util/include/linux/rbtree.h
@@ -1,3 +1,2 @@
 #include <stdbool.h>
-#include <stdbool.h>
 #include "../../../../include/linux/rbtree.h"
-- 
1.7.7.3
