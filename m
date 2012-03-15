Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031573Ab2COP6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:58:31 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:33420 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031531Ab2COP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:58:27 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        dmitry.torokhov@gmail.com, mpm@selenic.com,
        herbert@gondor.hengli.com.au, vinod.koul@intel.com,
        a.zummo@towertech.it, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/6] AT91 drivers Kconfig cleanup
Date: Thu, 15 Mar 2012 16:57:16 +0100
Message-Id: <cover.1331826095.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series which deals with AT91 drivers Kconfig entries. Its goal is
to remove too restrictive dependencies on SoC names.
This will allow to add support for newer SoC seamlessly.

One question remains: should I submit those patches through dedicated
sub-maintainer's git trees or can I queue the whole series in arm-soc?

Nicolas Ferre (6):
  dmaengine: Kconfig: fix Atmel at_hdmac entry
  mmc: Kconfig: remove choice between at91_mci and atmel-mci
  mmc: atmel-mci: remove the need for CONFIG_MMC_ATMELMCI_DMA
  rtc: Kconfig: remove dependency for AT91 rtc driver
  Input: Kconfig: remove dependency for atmel_tsadcc driver
  hwrng: Kconfig: remove dependency for atmel-rng driver

 drivers/char/hw_random/Kconfig    |    2 +-
 drivers/dma/Kconfig               |    5 ++---
 drivers/input/touchscreen/Kconfig |    4 ++--
 drivers/mmc/host/Kconfig          |   23 ++---------------------
 drivers/mmc/host/atmel-mci.c      |    2 --
 drivers/rtc/Kconfig               |    2 +-
 6 files changed, 8 insertions(+), 30 deletions(-)

Best regards,
-- 
1.7.9

