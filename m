Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2AXNbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 08:31:46 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:35567 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab2AXNbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 08:31:44 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: kernel-janitors@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch/hexagon/kernel/dma.c: make function static
Date: Tue, 24 Jan 2012 14:31:36 +0100
Message-Id: <1327411896-4532-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

This function is only used in the same file, and the other similar
functions in this file are also static.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/hexagon/kernel/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/kernel/dma.c b/arch/hexagon/kernel/dma.c
index 54891e1..0b49a0a 100644
--- a/arch/hexagon/kernel/dma.c
+++ b/arch/hexagon/kernel/dma.c
@@ -54,7 +54,7 @@ static struct gen_pool *coherent_pool;
 
 /* Allocates from a pool of uncached memory that was reserved at boot time */
 
-void *hexagon_dma_alloc_coherent(struct device *dev, size_t size,
+static void *hexagon_dma_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t flag)
 {
 	void *ret;

