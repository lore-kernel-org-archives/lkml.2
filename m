Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0KMDaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:30:39 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48513 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab0KMDaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:30:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61718505"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 01/14] msm: iommu: Increase maximum MID size to 5 bits
Date: Fri, 12 Nov 2010 19:29:47 -0800
Message-Id: <1289619000-13167-2-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On msm8x60, the MID field on the AXI connection to the
IOMMU can be up to five bits wide. Thus, allow the IOMMU
context platform data to map up to 32 MIDs.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/iommu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/iommu.h b/arch/arm/mach-msm/include/mach/iommu.h
index 218ef57..17fc79f 100644
--- a/arch/arm/mach-msm/include/mach/iommu.h
+++ b/arch/arm/mach-msm/include/mach/iommu.h
@@ -26,7 +26,7 @@
  * be present. These mappings are typically determined at design time and are
  * not expected to change at run time.
  */
-#define MAX_NUM_MIDS	16
+#define MAX_NUM_MIDS	32
 
 /**
  * struct msm_iommu_dev - a single IOMMU hardware instance
-- 
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

