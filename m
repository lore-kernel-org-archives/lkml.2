Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab2GYGaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:30:21 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41003 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab2GYGaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:30:16 -0400
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Katsuya MATSUBARA <matsu@igel.co.jp>, Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH 1/3] ARM: dma-mapping: define ARCH_HAS_DMA_MMAP_COHERENT
Date: Wed, 25 Jul 2012 15:29:22 +0900
Message-Id: <1343197764-13659-2-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1343197764-13659-1-git-send-email-hdk@igel.co.jp>
References: <1343197764-13659-1-git-send-email-hdk@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_HAS_DMA_MMAP_COHERENT indicates that there is dma_mmap_coherent() API
in this architecture.  The name is already defined in PowerPC.

Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
---
 arch/arm/include/asm/dma-mapping.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index bbef15d..f41cd30 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -187,6 +187,7 @@ extern int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 			struct dma_attrs *attrs);
 
 #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, NULL)
+#define ARCH_HAS_DMA_MMAP_COHERENT
 
 static inline int dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 				  void *cpu_addr, dma_addr_t dma_addr,
-- 
1.7.0.4

