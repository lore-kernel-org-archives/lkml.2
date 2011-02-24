Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab1BXWT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 17:19:27 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26421 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab1BXWTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 17:19:22 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76315575"
From: Kenneth Heitke <kheitke@codeaurora.org>
To: davidb@codeaurora.org, dima@android.com
Cc: linux-arm-msm@vger.kernel.org, tsoni@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, swetland@google.com,
        Kenneth Heitke <kheitke@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] MAINTAINERS: Add drivers/msm to MSM subsystem
Date: Thu, 24 Feb 2011 15:19:13 -0700
Message-Id: <1298585954-22422-2-git-send-email-kheitke@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1298585954-22422-1-git-send-email-kheitke@codeaurora.org>
References: <1298585954-22422-1-git-send-email-kheitke@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f99e12..e2ca70b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -889,6 +889,7 @@ M:	Daniel Walker <dwalker@fifo99.com>
 M:	Bryan Huntsman <bryanh@codeaurora.org>
 L:	linux-arm-msm@vger.kernel.org
 F:	arch/arm/mach-msm/
+F:	drivers/msm/
 F:	drivers/video/msm/
 F:	drivers/mmc/host/msm_sdcc.c
 F:	drivers/mmc/host/msm_sdcc.h
-- 
1.7.3.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
