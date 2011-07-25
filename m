Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1GYRTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:19:31 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40341 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1GYRT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:19:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6418"; a="105550800"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        David Brown <davidb@codeaurora.org>
Subject: [PATCHv2 2/2] ARM: ARM_PATCH_PHYS_VIRT_16BIT no longer depends on MSM
Date: Mon, 25 Jul 2011 10:19:22 -0700
Message-Id: <1311614362-9011-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.6.233.gd79bc
In-Reply-To: <1311614362-9011-1-git-send-email-sboyd@codeaurora.org>
References: <1311614362-9011-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSM no longer requires the 16bit version of dynamic P2V. Drop the
dependency.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: David Brown <davidb@codeaurora.org>
---
 arch/arm/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c24f97a..da4508d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -209,8 +209,8 @@ config ARM_PATCH_PHYS_VIRT
 	  for the MSM machine class.
 
 config ARM_PATCH_PHYS_VIRT_16BIT
-	def_bool y
-	depends on ARM_PATCH_PHYS_VIRT && ARCH_MSM
+	bool
+	depends on ARM_PATCH_PHYS_VIRT
 	help
 	  This option extends the physical to virtual translation patching
 	  to allow physical memory down to a theoretical minimum of 64K
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

