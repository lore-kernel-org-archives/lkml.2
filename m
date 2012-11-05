Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab2KEOuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:50:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34624 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab2KEOus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:50:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, sjenning@linux.vnet.ibm.com,
        dan.magenheimer@oracle.com, ngupta@vflare.org, minchan@kernel.org,
        rcj@linux.vnet.ibm.com, linux-mm@kvack.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org
Cc: akpm@linux-foundation.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/11] zcache: Module license is defined twice.
Date: Mon,  5 Nov 2012 09:37:25 -0500
Message-Id: <1352126254-28933-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352126254-28933-1-git-send-email-konrad.wilk@oracle.com>
References: <1352126254-28933-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other (same license) is at the end of the file.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/ramster/zcache-main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ramster/zcache-main.c b/drivers/staging/ramster/zcache-main.c
index 5c0c7db..2b9ad55 100644
--- a/drivers/staging/ramster/zcache-main.c
+++ b/drivers/staging/ramster/zcache-main.c
@@ -67,8 +67,6 @@ static char *namestr __read_mostly = "zcache";
 #define ZCACHE_GFP_MASK \
 	(__GFP_FS | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOMEMALLOC)
 
-MODULE_LICENSE("GPL");
-
 /* crypto API for zcache  */
 #ifdef CONFIG_ZCACHE2_MODULE
 static char *zcache_comp_name = "lzo";
-- 
1.7.7.6

