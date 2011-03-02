Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1CBVS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:18:29 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20108 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab1CBVS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:18:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77438423"
X-IronPort-AV: E=Sophos;i="4.62,253,1297065600"; 
   d="scan'208";a="56219555"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Dima Zavin <dima@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH 4/4] [ARM] msm: mdp: Set the correct pack pattern for XRGB/ARGB
Date: Wed,  2 Mar 2011 13:18:19 -0800
Message-Id: <1299100699-11705-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
References: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dima Zavin <dima@android.com>

Signed-off-by: Dima Zavin <dima@android.com>
Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp_hw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index 9e1e92e..d804774 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -489,7 +489,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 	MDP_GET_PACK_PATTERN(0, CLR_R, CLR_G, CLR_B, 8)
 #define PPP_PACK_PATTERN_MDP_RGB_888 PPP_PACK_PATTERN_MDP_RGB_565
 #define PPP_PACK_PATTERN_MDP_XRGB_8888 \
-	MDP_GET_PACK_PATTERN(CLR_ALPHA, CLR_R, CLR_G, CLR_B, 8)
+	MDP_GET_PACK_PATTERN(CLR_B, CLR_G, CLR_R, CLR_ALPHA, 8)
 #define PPP_PACK_PATTERN_MDP_ARGB_8888 PPP_PACK_PATTERN_MDP_XRGB_8888
 #define PPP_PACK_PATTERN_MDP_RGBA_8888 \
 	MDP_GET_PACK_PATTERN(CLR_ALPHA, CLR_B, CLR_G, CLR_R, 8)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

