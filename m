Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1JLQIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:08:07 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:11553 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1JLQIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:08:04 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, robherring2@gmail.com,
        claudio@evidence.eu.com, jesper.nilsson@axis.com,
        alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 3/5] tty/serial: atmel_serial: whitespace and braces modifications
Date: Wed, 12 Oct 2011 18:06:58 +0200
Message-Id: <e4c59e6f5ee33c1be57085ac0840b53322526367.1318433947.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318435620-7481-1-git-send-email-nicolas.ferre@atmel.com>
References: <1318435620-7481-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <37a19e194d02144aecd24f284f5e43979643a3c3.1318433947.git.nicolas.ferre@atmel.com>
References: <37a19e194d02144aecd24f284f5e43979643a3c3.1318433947.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/tty/serial/atmel_serial.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index a507daa..bb72354 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1433,10 +1433,10 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 
 	memset(&atmel_port->rx_ring, 0, sizeof(atmel_port->rx_ring));
 
-	if (pdata->regs)
+	if (pdata->regs) {
 		/* Already mapped by setup code */
 		port->membase = pdata->regs;
-	else {
+	} else {
 		port->flags	|= UPF_IOREMAP;
 		port->membase	= NULL;
 	}
@@ -1450,9 +1450,10 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 		/* only enable clock when USART is in use */
 	}
 
-	atmel_port->use_dma_rx = pdata->use_dma_rx;
-	atmel_port->use_dma_tx = pdata->use_dma_tx;
+	atmel_port->use_dma_rx	= pdata->use_dma_rx;
+	atmel_port->use_dma_tx	= pdata->use_dma_tx;
 	atmel_port->rs485	= pdata->rs485;
+
 	/* Use TXEMPTY for interrupt when rs485 else TXRDY or ENDTX|TXBUFE */
 	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
 		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
-- 
1.7.5.4

