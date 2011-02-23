Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1BWAEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:04:07 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6768 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1BWAEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:04:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6265"; a="76057162"
From: David Brown <davidb@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH] MAINTAINERS: Update MSM maintainers
Date: Tue, 22 Feb 2011 16:03:35 -0800
Message-Id: <1298419415-3973-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove Bryan Huntsman and Daniel Walker from the MSM maintainer list.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 MAINTAINERS |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f99e12..c6c6f55 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -885,8 +885,6 @@ S:	Supported
 
 ARM/QUALCOMM MSM MACHINE SUPPORT
 M:	David Brown <davidb@codeaurora.org>
-M:	Daniel Walker <dwalker@fifo99.com>
-M:	Bryan Huntsman <bryanh@codeaurora.org>
 L:	linux-arm-msm@vger.kernel.org
 F:	arch/arm/mach-msm/
 F:	drivers/video/msm/
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

