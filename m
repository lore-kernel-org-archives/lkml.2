Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1JDH2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:28:34 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14934 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071Ab1JDH2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:28:32 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH] pch_dma: Fix suspend issue
Date: Tue,  4 Oct 2011 16:27:59 +0900
Message-Id: <1317713279-2774-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, executing suspend/hibernation,
memory access violation occurs.

This patch fixes the issue
 - Modify array size (MAX_CHAN_NR)

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/dma/pch_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 1ac8d4b..42bcc80 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -60,7 +60,7 @@
 #define DMA_DESC_FOLLOW_WITHOUT_IRQ	0x2
 #define DMA_DESC_FOLLOW_WITH_IRQ	0x3
 
-#define MAX_CHAN_NR			8
+#define MAX_CHAN_NR			12
 
 #define DMA_MASK_CTL0_MODE	0x33333333
 #define DMA_MASK_CTL2_MODE	0x00003333
-- 
1.7.4.4

