Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423392Ab2KNTN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:13:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30881 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423285Ab2KNTNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:13:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: sjenning@linux.vnet.ibm.com, dan.magenheimer@oracle.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, minchan@kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de
Cc: fschmaus@gmail.com, andor.daam@googlemail.com, ilendir@googlemail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 10/11] zcache: Module license is defined twice.
Date: Wed, 14 Nov 2012 14:12:18 -0500
Message-Id: <1352920339-10183-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352920339-10183-1-git-send-email-konrad.wilk@oracle.com>
References: <1352920339-10183-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other (same license) is at the end of the file.

Reviewed-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/ramster/zcache-main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ramster/zcache-main.c b/drivers/staging/ramster/zcache-main.c
index 457e41c..a1a9799 100644
--- a/drivers/staging/ramster/zcache-main.c
+++ b/drivers/staging/ramster/zcache-main.c
@@ -68,8 +68,6 @@ static char *namestr __read_mostly = "zcache";
 #define ZCACHE_GFP_MASK \
 	(__GFP_FS | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOMEMALLOC)
 
-MODULE_LICENSE("GPL");
-
 /* crypto API for zcache  */
 #ifdef CONFIG_ZCACHE2_MODULE
 static char *zcache_comp_name = "lzo";
-- 
1.7.7.6

