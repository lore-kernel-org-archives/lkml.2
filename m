Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0G1RWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:22:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15369 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab0G1RWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:22:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="48949216"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 1/2] arm: msm: Fix section mismatch in smd.c.
Date: Wed, 28 Jul 2010 10:22:12 -0700
Message-Id: <1280337733-18707-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repair a section mismatch between the smd driver's
platform_driver structure and its probe method.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/smd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c
index cf11d41..f07dc7c 100644
--- a/arch/arm/mach-msm/smd.c
+++ b/arch/arm/mach-msm/smd.c
@@ -997,7 +997,7 @@ int smd_core_init(void)
 	return 0;
 }
 
-static int __init msm_smd_probe(struct platform_device *pdev)
+static int __devinit msm_smd_probe(struct platform_device *pdev)
 {
 	pr_info("smd_init()\n");
 
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
