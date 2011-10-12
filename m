Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1JLQ5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:57:25 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:30743 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JLQ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:57:24 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Subject: [PATCH v3 0/4] dmaengine: Device Tree support for Atmel DMA
Date: Wed, 12 Oct 2011 18:57:10 +0200
Message-Id: <1318438634-11826-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the device tree support to Atmel DMA controller driver:
at_hdmac.
The removal of platform data ease the conversion to device tree. It also have
the additional benefit of being simpler and cleaner.

Nicolas Ferre (4):
      dmaengine: at_hdmac: platform data move to use .id_table
      dmaengine: at_hdmac: add device tree support
      ARM: at91/dma: remove platform data from DMA controller
      ARM: at91/dma: DMA controller registering with DT support

 .../devicetree/bindings/dma/atmel-dma.txt          |   14 ++++
 arch/arm/mach-at91/at91sam9g45_devices.c           |   17 ++---
 arch/arm/mach-at91/at91sam9rl_devices.c            |    8 +--
 arch/arm/mach-at91/include/mach/at_hdmac.h         |   10 ---
 drivers/dma/at_hdmac.c                             |   76 +++++++++++++++++---
 drivers/dma/at_hdmac_regs.h                        |    8 ++
 6 files changed, 97 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/atmel-dma.txt

Best regards,
-- 
Nicolas Ferre
