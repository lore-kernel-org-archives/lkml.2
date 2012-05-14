Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2ENIpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:45:43 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59482 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2ENIpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:45:12 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-81-4fb0c6137c67
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 2/3] zram: remove comment in Kconfig
Date: Mon, 14 May 2012 17:45:32 +0900
Message-Id: <1336985134-31967-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336985134-31967-1-git-send-email-minchan@kernel.org>
References: <1336985134-31967-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exactly speaking, zram should has dependency with
zsmalloc, not x86. So x86 dependeny check is redundant.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
index 9d11a4c..ee23a86 100644
--- a/drivers/staging/zram/Kconfig
+++ b/drivers/staging/zram/Kconfig
@@ -1,8 +1,6 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
-	# X86 dependency is because zsmalloc uses non-portable pte/tlb
-	# functions
-	depends on BLOCK && SYSFS && X86
+	depends on BLOCK && SYSFS
 	select ZSMALLOC
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
-- 
1.7.9.5

