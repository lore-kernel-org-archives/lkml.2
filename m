Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710Ab0HESbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:31:21 -0400
Received: from xenotime.net ([72.52.115.56]:49300 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758576Ab0HESbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:31:07 -0400
Date: Thu, 05 Aug 2010 11:23:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 2/7] Documentation/vm: fix spelling in page-types.c
Message-ID: <12810325914046@xenotime.net>
In-Reply-To: <12810325911230@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tommi Rantala <tt.rantala@gmail.com>

Trivial typo fixes.

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/vm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-rc3.orig/Documentation/vm/page-types.c
+++ linux-2.6.35-rc3/Documentation/vm/page-types.c
@@ -694,7 +694,7 @@ static void usage(void)
 #endif
 "            -l|--list                  Show page details in ranges\n"
 "            -L|--list-each             Show page details one by one\n"
-"            -N|--no-summary            Don't show summay info\n"
+"            -N|--no-summary            Don't show summary info\n"
 "            -X|--hwpoison              hwpoison pages\n"
 "            -x|--unpoison              unpoison pages\n"
 "            -h|--help                  Show this usage message\n"


-- 

