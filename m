Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab2EJKSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:18:25 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:51424 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab2EJKSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:18:24 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <vinod.koul@linux.intel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/3] dmaengine: at_hdmac: slave configuration
Date: Thu, 10 May 2012 12:17:38 +0200
Message-ID: <cover.1336644470.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is composed of two cleanup patches and one "slave
configuration" patch. The last one uses configuration data passed through the
slave configuration API to setup the DMA controller.
Corresponding custom configuration is removed from the slave DMA private
structure and its use in the AT91 files. Header definitions are then moved
accordingly.

Nicolas Ferre (3):
  dmaengine: at_hdmac: remove some at_dma_slave comments
  dmaengine: at_hdmac: remove ATC_DEFAULT_CTRLA constant
  dmaengine: at_hdmac: take maxburst from slave configuration

 arch/arm/mach-at91/at91sam9g45_devices.c   |    1 -
 arch/arm/mach-at91/include/mach/at_hdmac.h |   26 --------------------------
 drivers/dma/at_hdmac.c                     |   15 +++++++--------
 drivers/dma/at_hdmac_regs.h                |   21 ++++++++++++++++++++-
 4 files changed, 27 insertions(+), 36 deletions(-)

-- 
1.7.10

