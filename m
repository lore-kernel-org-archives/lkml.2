Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1FZVdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:33:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41610 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab1FZVc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:32:26 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 2/2] dmaengine: remove ste_dma40 from issue_pending TODO
Date: Sun, 26 Jun 2011 23:29:53 +0200
Message-Id: <1309123793-7806-3-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309123793-7806-1-git-send-email-per.forlin@linaro.org>
References: <1309123793-7806-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ste_dma40 now implements issue_pending according to documentation.
Submit adds descriptos to a pending queue with are flushed down to the DMAC
at issue_pending.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/dma/TODO |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/TODO b/drivers/dma/TODO
index a4af858..734ed02 100644
--- a/drivers/dma/TODO
+++ b/drivers/dma/TODO
@@ -9,6 +9,5 @@ TODO for slave dma
 	- mxs-dma.c
 	- dw_dmac
 	- intel_mid_dma
-	- ste_dma40
 4. Check other subsystems for dma drivers and merge/move to dmaengine
 5. Remove dma_slave_config's dma direction.
-- 
1.7.4.1

