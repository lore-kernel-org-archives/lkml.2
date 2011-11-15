Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab1KOXcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:32:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38837 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757309Ab1KOXca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:32:30 -0500
From: Joe Perches <joe@perches.com>
To: linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-arm-msm@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mmc: logging neatening and mmc_host_<level>
Date: Tue, 15 Nov 2011 15:32:04 -0800
Message-Id: <cover.1321398814.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (4):
  mmc: Update logging style
  wbsd: Use current logging
  mmc: Logging neatening
  mmc: Add mmc_host_<level> logging

 drivers/mmc/card/block.c        |    4 +-
 drivers/mmc/card/mmc_test.c     |   77 ++++++---------
 drivers/mmc/card/queue.c        |    6 +-
 drivers/mmc/card/sdio_uart.c    |   10 +-
 drivers/mmc/core/bus.c          |   27 ++---
 drivers/mmc/core/core.c         |  116 ++++++++++-----------
 drivers/mmc/core/host.c         |   14 +--
 drivers/mmc/core/mmc.c          |   75 +++++---------
 drivers/mmc/core/mmc_ops.c      |   12 +--
 drivers/mmc/core/sd.c           |   73 +++++---------
 drivers/mmc/core/sdio.c         |   11 +--
 drivers/mmc/core/sdio_bus.c     |    6 +-
 drivers/mmc/core/sdio_cis.c     |   10 +-
 drivers/mmc/core/sdio_io.c      |   14 ++-
 drivers/mmc/core/sdio_irq.c     |   24 ++--
 drivers/mmc/host/at91_mci.c     |   12 +-
 drivers/mmc/host/au1xmmc.c      |   35 +++---
 drivers/mmc/host/bfin_sdh.c     |    3 +-
 drivers/mmc/host/dw_mmc.c       |   18 ++--
 drivers/mmc/host/mmc_spi.c      |    9 +-
 drivers/mmc/host/mmci.c         |    8 +-
 drivers/mmc/host/msm_sdcc.c     |  101 ++++++++----------
 drivers/mmc/host/mvsdio.c       |   42 +++-----
 drivers/mmc/host/omap_hsmmc.c   |   19 +---
 drivers/mmc/host/pxamci.c       |    4 +-
 drivers/mmc/host/s3cmci.c       |    3 +-
 drivers/mmc/host/sdhci-pci.c    |   17 ++--
 drivers/mmc/host/sdhci-pxav3.c  |    7 +-
 drivers/mmc/host/sdhci.c        |  218 +++++++++++++++++----------------------
 drivers/mmc/host/sdricoh_cs.c   |   12 +-
 drivers/mmc/host/tifm_sd.c      |   12 +--
 drivers/mmc/host/tmio_mmc.c     |    4 +-
 drivers/mmc/host/tmio_mmc_pio.c |    4 +-
 drivers/mmc/host/via-sdmmc.c    |   33 +++----
 drivers/mmc/host/vub300.c       |   54 +++++-----
 drivers/mmc/host/wbsd.c         |   72 ++++++--------
 include/linux/mmc/host.h        |   11 ++
 37 files changed, 510 insertions(+), 667 deletions(-)

-- 
1.7.6.405.gc1be0

