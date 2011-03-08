Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1CHTHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:07:35 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6778 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1CHTHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:07:32 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6279"; a="78545091"
From: Kenneth Heitke <kheitke@codeaurora.org>
To: davidb@codeaurora.org, bryanh@codeaurora.org, dwalker@fifo99.com,
        akpm@linux-foundation.org, joe@perches.com, davem@davemloft.net,
        gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kenneth Heitke <kheitke@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/2] MAINTAINERS: Add drivers/platform/msm to MSM subsystem
Date: Tue,  8 Mar 2011 12:07:26 -0700
Message-Id: <1299611247-16785-1-git-send-email-kheitke@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 59869e4..696cb18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -904,6 +904,7 @@ F:	drivers/mmc/host/msm_sdcc.c
 F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
+F:	drivers/platform/msm/
 T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
 S:	Maintained
 
-- 
1.7.3.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
