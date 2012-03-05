Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2CEXGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:06:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:62428 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab2CEXGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:06:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115032622"
Date: Mon, 5 Mar 2012 15:06:02 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] writeback: fix typo in the writeback_control comment
Message-ID: <20120305230602.GA19073@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org> 

Signed-off-by: Andrew Morton <akpm@linux-foundation.org> 
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 include/linux/writeback.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/include/linux/writeback.h	2012-03-01 12:51:45.474351141 +0800
+++ linux/include/linux/writeback.h	2012-03-02 12:56:43.913665799 +0800
@@ -64,7 +64,7 @@ struct writeback_control {
 	long pages_skipped;		/* Pages which were not written */
 
 	/*
-	 * For a_ops->writepages(): is start or end are non-zero then this is
+	 * For a_ops->writepages(): if start or end are non-zero then this is
 	 * a hint that the filesystem need only write out the pages inside that
 	 * byterange.  The byte at `end' is included in the writeout request.
 	 */
