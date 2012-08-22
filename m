Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab2HVXAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:00:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19782 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229Ab2HVXAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:00:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6812"; a="226086640"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] ARM: MSM: Add msm8660-surf.dts to Makefile.boot
Date: Wed, 22 Aug 2012 16:00:14 -0700
Message-Id: <1345676414-16635-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345676414-16635-1-git-send-email-sboyd@codeaurora.org>
References: <1345676414-16635-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this entry to the Makefile so that we can build the dtb
automatically with 'make dtbs'.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile.boot | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-msm/Makefile.boot b/arch/arm/mach-msm/Makefile.boot
index 9b803a5..8de0678 100644
--- a/arch/arm/mach-msm/Makefile.boot
+++ b/arch/arm/mach-msm/Makefile.boot
@@ -1,3 +1,5 @@
   zreladdr-y		+= 0x10008000
 params_phys-y		:= 0x10000100
 initrd_phys-y		:= 0x10800000
+
+dtb-$(CONFIG_ARCH_MSM8X60) += msm8660-surf.dtb
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

