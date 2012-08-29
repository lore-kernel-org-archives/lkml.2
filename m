Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab2H2Esw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 00:48:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51184 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2H2Esv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 00:48:51 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, kgene.kim@samsung.com, jaswinder.singh@linaro.org,
        patches@linaro.org
Subject: [PATCH 0/2] ARM: EXYNOS: Set the capability of pdm0 and pdm1 as DMA_PRIVATE
Date: Wed, 29 Aug 2012 10:16:23 +0530
Message-Id: <1346215585-31023-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA clients pdma0 and pdma1 are internal to the SoC and are used only
by dedicated peripherals. Since they cannot be used for generic
purpose, their capability should be set as DMA_PRIVATE.

The patches are rebased on top of v3.6-rc3.

Tushar Behera (2):
  ARM: EXYNOS: Set the capability of pdm0 and pdm1 as DMA_PRIVATE
  DMA: PL330: Set the capability of pdm0 and pdm1 as DMA_PRIVATE

 arch/arm/mach-exynos/dma.c |    2 ++
 drivers/dma/pl330.c        |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

-- 
1.7.4.1

