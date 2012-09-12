Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741Ab2ILRD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:03:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40226 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab2ILQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521337"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 08/24] ARM: msm: Add msm8660-surf.dts to Makefile.boot
Date: Wed, 12 Sep 2012 09:58:44 -0700
Message-Id: <1347469140-25069-9-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Add this entry to the Makefile so that we can build the dtb
automatically with 'make dtbs'.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

