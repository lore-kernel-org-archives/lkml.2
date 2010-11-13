Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0KMDbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:31:01 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48513 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0KMDaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:30:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61718510"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 11/14] msm: iommu: Kconfig dependency for the IOMMU API
Date: Fri, 12 Nov 2010 19:29:57 -0800
Message-Id: <1289619000-13167-12-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the IOMMU driver select the IOMMU API in the kernel
configuration.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 7781920..2f7ca4c 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -44,6 +44,7 @@ config ARCH_MSM8X60
 	select CPU_V7
 	select MSM_V2_TLMM
 	select MSM_GPIOMUX
+	select IOMMU_API
 
 endchoice
 
@@ -177,4 +178,7 @@ config MSM_GPIOMUX
 
 config MSM_V2_TLMM
 	bool
+
+config IOMMU_API
+	bool
 endif
-- 
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

