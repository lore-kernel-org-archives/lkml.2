Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab2LPRY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:24:58 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43767 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2LPRY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:24:56 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 05/14] ARM: iommu: Include linux/kref.h in asm/dma-iommu.h
Date: Sun, 16 Dec 2012 18:25:51 +0100
Message-Id: <1355678760-27357-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_iommu_mapping structure defined in asm/dma-iommu.h embeds a
struct kref, include the appropriate header file.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/include/asm/dma-iommu.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/dma-iommu.h b/arch/arm/include/asm/dma-iommu.h
index 799b094..666d8a8 100644
--- a/arch/arm/include/asm/dma-iommu.h
+++ b/arch/arm/include/asm/dma-iommu.h
@@ -7,6 +7,7 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-debug.h>
 #include <linux/kmemcheck.h>
+#include <linux/kref.h>
 
 struct dma_iommu_mapping {
 	/* iommu specific data */
-- 
1.7.8.6

