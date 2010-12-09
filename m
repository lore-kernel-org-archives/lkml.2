Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab0LIXps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:45:48 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42012 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab0LIXpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:45:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6192"; a="66210587"
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH] MAINTAINERS: update MSM git tree
Date: Thu,  9 Dec 2010 15:45:27 -0800
Message-Id: <1291938327-22243-1-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSM main git tree has changed over to this new address.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1a1c27b..34d44ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -815,7 +815,7 @@ F:	drivers/mmc/host/msm_sdcc.c
 F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/serial/msm_serial.h
 F:	drivers/serial/msm_serial.c
-T:	git git://codeaurora.org/quic/kernel/dwalker/linux-msm.git
+T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
 S:	Maintained
 
 ARM/TOSA MACHINE SUPPORT
-- 
1.7.0.4

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
