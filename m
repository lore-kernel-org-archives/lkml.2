Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab1LFKtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:49:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61550 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092Ab1LFKtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:49:19 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, vinod.koul@intel.com, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH 0/2] Add PM_RUNTIME related fixes for PL330
Date: Tue,  6 Dec 2011 16:15:53 +0530
Message-Id: <1323168355-2764-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When PM_RUNTIME is enabled, PL330 probe fails because of some
mismatch in pm_runtime calls. This patchset fixes those issues.

This patch is based on Kukjin's for-next branch and tested on
EXYNOS4 based Origen board.

d3d936c "Merge branch 'samsung-fixes-2' into for-next"

Tushar Behera (2):
To Vinod Koul <vinod.koul@intel.com>:
  DMA: PL330: Remove pm_runtime_xxx calls from pl330 probe/remove

To Kukjin Kim <kgene.kim@samsung.com>:
  ARM: EXYNOS: Add apb_pclk clkdev entry for mdma1

 arch/arm/mach-exynos/clock.c |    1 +
 drivers/dma/pl330.c          |   17 ++---------------
 2 files changed, 3 insertions(+), 15 deletions(-)

-- 
1.7.4.1

