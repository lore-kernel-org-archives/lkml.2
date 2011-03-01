Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1CAAFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:05:07 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42317 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab1CAAFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:05:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6271"; a="77012426"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 2/2] msm: iommu: Enable HTW L2 redirection on MSM8960
Date: Mon, 28 Feb 2011 16:04:56 -0800
Message-Id: <1298937896-29324-2-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1298937896-29324-1-git-send-email-stepanm@codeaurora.org>
References: <1298937896-29324-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the MSM8960 IOMMU to access its page tables directly
through the L2 cache.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 997c5bd..1516896 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -162,7 +162,7 @@ config MSM_IOMMU

 config IOMMU_PGTABLES_L2
 	def_bool y
-	depends on ARCH_MSM8X60 && MMU && SMP && CPU_DCACHE_DISABLE=n
+	depends on MSM_IOMMU && MMU && SMP && CPU_DCACHE_DISABLE=n

 config MSM_DEBUG_UART
 	int
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

