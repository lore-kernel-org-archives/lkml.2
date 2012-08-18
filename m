Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2HRRcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:32:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:9940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab2HRRab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="210330067"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 18/31] sections: Fix section conflicts in drivers/mfd
Date: Sat, 18 Aug 2012 10:30:09 -0700
Message-Id: <1345311022-26328-19-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/mfd/wm8994-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index eec74aa..45e268b 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -374,21 +374,21 @@ static int wm8994_ldo_in_use(struct wm8994_pdata *pdata, int ldo)
 }
 #endif
 
-static const __devinitdata struct reg_default wm8994_revc_patch[] = {
+static const __devinitconst struct reg_default wm8994_revc_patch[] = {
 	{ 0x102, 0x3 },
 	{ 0x56, 0x3 },
 	{ 0x817, 0x0 },
 	{ 0x102, 0x0 },
 };
 
-static const __devinitdata struct reg_default wm8958_reva_patch[] = {
+static const __devinitconst struct reg_default wm8958_reva_patch[] = {
 	{ 0x102, 0x3 },
 	{ 0xcb, 0x81 },
 	{ 0x817, 0x0 },
 	{ 0x102, 0x0 },
 };
 
-static const __devinitdata struct reg_default wm1811_reva_patch[] = {
+static const __devinitconst struct reg_default wm1811_reva_patch[] = {
 	{ 0x102, 0x3 },
 	{ 0x56, 0x7 },
 	{ 0x5d, 0x7e },
-- 
1.7.7.6

