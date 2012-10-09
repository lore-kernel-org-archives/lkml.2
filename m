Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2JIXpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:45:42 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44625 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2JIXpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:45:41 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-db-5074b7223fae
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>
Subject: [PATCH] zram: correct obsolete comment on max_zpage_size
Date: Wed, 10 Oct 2012 08:49:52 +0900
Message-Id: <1349826592-27965-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zram doesn't use xv_malloc any more so it doesn't have
limitation about zobj_header.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 572c0b1..df2eec4 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -39,8 +39,8 @@ static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
 
 /*
  * NOTE: max_zpage_size must be less than or equal to:
- *   ZS_MAX_ALLOC_SIZE - sizeof(struct zobj_header)
- * otherwise, xv_malloc() would always return failure.
+ *   ZS_MAX_ALLOC_SIZE. Otherwise, zs_malloc() would
+ * always return failure.
  */
 
 /*-- End of configurable params */
-- 
1.7.9.5

