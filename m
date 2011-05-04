Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1EDIOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:14:34 -0400
Received: from mx5.orcon.net.nz ([219.88.242.55]:38155 "EHLO mx5.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab1EDIOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:14:32 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: linux-kernel@vger.kernel.org
Cc: Michael Cree <mcree@orcon.net.nz>, linux-alpha@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH] alpha: Add DMA_ERROR_CODE defn to avert compiler error in drm
Date: Wed,  4 May 2011 20:13:37 +1200
Message-Id: <1304496817-7646-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.4.3
X-DSPAM-Check: by mx5.orcon.net.nz on Wed, 04 May 2011 20:14:31 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed May  4 20:14:31 2011
X-DSPAM-Confidence: 0.7624
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The radeon drm code now relies on DMA_ERROR_CODE.  This defines
it in alpha dma-mapping header to at least enable me to compile
radeon drm/kms into kernel.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/include/asm/dma-mapping.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
index 4567aca..644d9c3 100644
--- a/arch/alpha/include/asm/dma-mapping.h
+++ b/arch/alpha/include/asm/dma-mapping.h
@@ -3,6 +3,8 @@
 
 #include <linux/dma-attrs.h>
 
+#define DMA_ERROR_CODE 0
+
 extern struct dma_map_ops *dma_ops;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
-- 
1.7.4.3

