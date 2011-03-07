Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab1CGVsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:48:46 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32682 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab1CGVsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:48:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6278"; a="78342567"
From: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: will.deacon@arm.com, robert.richter@amd.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sheetal Sahasrabudhe <sheetals@codeaurora.org>
Subject: [PATCH v2 3/3] [ARM] Oprofile: Add Qualcomm Scorpion and ScorpionMP CPU type
Date: Mon,  7 Mar 2011 16:48:38 -0500
Message-Id: <1299534518-25856-1-git-send-email-sheetals@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds Qualcomm Scorpion and ScorpionMP CPU type
to Oprofile kernel driver.

Signed-off-by: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
Reviewed-by: Jean Pihet <j-pihet@ti.com>
---
 arch/arm/oprofile/common.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index c074e66..1a04f07 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -40,6 +40,10 @@ char *op_name_from_perf_id(void)
 		return "arm/armv7";
 	case ARM_PERF_PMU_ID_CA9:
 		return "arm/armv7-ca9";
+	case ARM_PERF_PMU_ID_SCORPION:
+		return "arm/armv7-scorpion";
+	case ARM_PERF_PMU_ID_SCORPIONMP:
+		return "arm/armv7-scorpionmp";
 	default:
 		return NULL;
 	}
-- 
1.7.4.1

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum

