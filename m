Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab0E0WF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:05:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39232 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab0E0WF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:05:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5995"; a="42750537"
Subject: [GIT PULL] MSM mmc_sdcc driver updates for 2.6.35-rc1
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 15:05:55 -0700
Message-ID: <1274997955.10998.48.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

	Small fix for the msm-mmc_sdcc driver, fixing a compile failure with
MSM7x30.

Daniel

The following changes since commit 1cd2296909e77702c68021ede9d87a1d967a6a99:

  drivers: mmc: msm_sdcc: Add EMBEDDED_SDIO support (2010-03-18 13:37:24 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-mmc_sdcc

Daniel Walker (1):
      mmc: msm: fix compile error on MSM7x30

 drivers/mmc/host/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index ce1d288..6fc8eec 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -240,7 +240,7 @@ config MMC_IMX
 
 config MMC_MSM7X00A
 	tristate "Qualcomm MSM 7X00A SDCC Controller Support"
-	depends on MMC && ARCH_MSM
+	depends on MMC && ARCH_MSM && !ARCH_MSM7X30
 	help
 	  This provides support for the SD/MMC cell found in the
           MSM 7X00A controllers from Qualcomm.


