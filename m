Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828Ab1IOULg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:11:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:46846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934770Ab1IOUKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="48899372"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, wim@iguana.be
Subject: [PATCH 24/27] Initconst section fixes for watchdog
Date: Thu, 15 Sep 2011 13:09:51 -0700
Message-Id: <1316117394-21666-25-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: wim@iguana.be
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/watchdog/sbc_epx_c3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index 3066a51..eaca366 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -173,7 +173,7 @@ static struct notifier_block epx_c3_notifier = {
 	.notifier_call = epx_c3_notify_sys,
 };
 
-static const char banner[] __initdata = KERN_INFO PFX
+static const char banner[] __initconst = KERN_INFO PFX
 	"Hardware Watchdog Timer for Winsystems EPX-C3 SBC: 0.1\n";
 
 static int __init watchdog_init(void)
-- 
1.7.4.4

