Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2EJKSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:18:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:51485 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706Ab2EJKSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:18:41 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <vinod.koul@linux.intel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/3] dmaengine: at_hdmac: remove some at_dma_slave comments
Date: Thu, 10 May 2012 12:17:39 +0200
Message-ID: <3eb4c8b2943e93fcaf9748d5923aa5a380477d98.1336644470.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1336644470.git.nicolas.ferre@atmel.com>
References: <cover.1336644470.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These comments were covering removed struct at_dma_slave fields.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/include/mach/at_hdmac.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/at_hdmac.h b/arch/arm/mach-at91/include/mach/at_hdmac.h
index fff48d1..810a13e 100644
--- a/arch/arm/mach-at91/include/mach/at_hdmac.h
+++ b/arch/arm/mach-at91/include/mach/at_hdmac.h
@@ -26,11 +26,6 @@ struct at_dma_platform_data {
 /**
  * struct at_dma_slave - Controller-specific information about a slave
  * @dma_dev: required DMA master device
- * @tx_reg: physical address of data register used for
- *	memory-to-peripheral transfers
- * @rx_reg: physical address of data register used for
- *	peripheral-to-memory transfers
- * @reg_width: peripheral register width
  * @cfg: Platform-specific initializer for the CFG register
  * @ctrla: Platform-specific initializer for the CTRLA register
  */
-- 
1.7.10

