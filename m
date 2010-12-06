Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0LFX3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:29:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26876 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab0LFXZK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 20/23] ia64: Add DMA_ERROR_CODE define.
Date: Mon,  6 Dec 2010 18:24:32 -0500
Message-Id: <1291677875-30493-21-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This piggybacks on git commit 8fd524b355daef0945692227e726fb444cebcd4f
("x86: Kill bad_dma_address variable") wherein we use now the
dma_map_ops->mapping_error to check for errors and the standard
check is against DMA_ERROR_CODE. Introduce it to the IA64 world.

CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/ia64/include/asm/dma-mapping.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index a2e7368..4336d08 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -12,6 +12,8 @@
 
 #define ARCH_HAS_DMA_GET_REQUIRED_MASK
 
+#define DMA_ERROR_CODE 0
+
 extern struct dma_map_ops *dma_ops;
 extern struct ia64_machine_vector ia64_mv;
 extern void set_iommu_machvec(void);
-- 
1.7.1

