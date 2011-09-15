Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841Ab1IOULw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:11:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:48932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934766Ab1IOUKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873447"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, dwmw2@infradead.org
Subject: [PATCH 18/27] Initconst section fixes for mtd
Date: Thu, 15 Sep 2011 13:09:45 -0700
Message-Id: <1316117394-21666-19-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: dwmw2@infradead.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/mtd/maps/wr_sbc82xx_flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/wr_sbc82xx_flash.c b/drivers/mtd/maps/wr_sbc82xx_flash.c
index 901ce96..4ded8af 100644
--- a/drivers/mtd/maps/wr_sbc82xx_flash.c
+++ b/drivers/mtd/maps/wr_sbc82xx_flash.c
@@ -60,7 +60,7 @@ static struct mtd_partition bigflash_parts[] = {
 	}
 };
 
-static const char *part_probes[] __initdata = {"cmdlinepart", "RedBoot", NULL};
+static const char * const part_probes[] __initconst = {"cmdlinepart", "RedBoot", NULL};
 
 #define init_sbc82xx_one_flash(map, br, or)			\
 do {								\
-- 
1.7.4.4

