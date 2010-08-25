Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab0HYE73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:59:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17528 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab0HYE60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012267"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366148"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH 18/24] msm: physical offset for MSM8X60
Date: Tue, 24 Aug 2010 21:57:47 -0700
Message-Id: <1282712273-344-19-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSM8x60 has a different physical memory offset than other targets.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/memory.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/memory.h b/arch/arm/mach-msm/include/mach/memory.h
index 50c7847..070e17d 100644
--- a/arch/arm/mach-msm/include/mach/memory.h
+++ b/arch/arm/mach-msm/include/mach/memory.h
@@ -23,6 +23,8 @@
 #define PHYS_OFFSET		UL(0x20000000)
 #elif defined(CONFIG_ARCH_MSM7X30)
 #define PHYS_OFFSET		UL(0x00200000)
+#elif defined(CONFIG_ARCH_MSM8X60)
+#define PHYS_OFFSET		UL(0x40200000)
 #else
 #define PHYS_OFFSET		UL(0x10000000)
 #endif
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
