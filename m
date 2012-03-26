Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2CZFm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:42:29 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62027 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2CZFmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:42:25 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/7] pch_uart: Delete unused structure member
Date: Mon, 26 Mar 2012 14:43:00 +0900
Message-Id: <1332740586-28496-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 332f2eb..80609e4 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -236,7 +236,6 @@ struct eg20t_port {
 	unsigned int fcr;
 	unsigned int mcr;
 	unsigned int use_dma;
-	unsigned int use_dma_flag;
 	struct dma_async_tx_descriptor	*desc_tx;
 	struct dma_async_tx_descriptor	*desc_rx;
 	struct pch_dma_slave		param_tx;
@@ -1445,7 +1444,6 @@ static int pch_uart_verify_port(struct uart_port *port,
 		return -EOPNOTSUPP;
 #endif
 		priv->use_dma = 1;
-		priv->use_dma_flag = 1;
 		dev_info(priv->port.dev, "PCH UART : Use DMA Mode\n");
 	}
 
-- 
1.7.7.6

