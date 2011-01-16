Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1APU3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 15:29:08 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16443 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab1APU3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 15:29:05 -0500
Date: Sun, 16 Jan 2011 21:29:03 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-mm@kvack.org
cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrea Arcangeli <andrea@suse.de>
Subject: [PATCH] mm: Remove duplicate include of compaction.h from vmscan.c
Message-ID: <alpine.LNX.2.00.1101162125150.13377@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/compaction.h is included twice in mm/vmscan.c - once is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 vmscan.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 99999a9..34edf0a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -41,7 +41,6 @@
 #include <linux/memcontrol.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
-#include <linux/compaction.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

