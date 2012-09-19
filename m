Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab2ISHBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:01:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26031 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab2ISHAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:00:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6839"; a="238452248"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Chris Ball <cjb@laptop.org>
Subject: [PATCH 2/5] mmc: msm_sdcc: Remove unnecessary include
Date: Wed, 19 Sep 2012 00:00:41 -0700
Message-Id: <1348038044-1790-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.403.gce5cf6f
In-Reply-To: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
References: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has no reason to include msm_iomap.h. Remove it so
that we can remove msm_iomap.h from include/mach in the future.

Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 1d14cda..8bcb330 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -43,7 +43,6 @@
 #include <asm/sizes.h>
 
 #include <mach/mmc.h>
-#include <mach/msm_iomap.h>
 #include <mach/dma.h>
 #include <mach/clk.h>
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

