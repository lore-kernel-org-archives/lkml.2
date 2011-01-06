Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1AFWXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:23:41 -0500
Received: from kroah.org ([198.145.64.141]:55625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab1AFWXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:37 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Baurzhan Ismagulov <ibr@radix50.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/36] serial: cpu_uart: Remove unused uart_cpm_port fields
Date: Thu,  6 Jan 2011 14:22:56 -0800
Message-Id: <1294352605-31906-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Baurzhan Ismagulov <ibr@radix50.net>

AFAICT, these fields are not used anywhere.

Signed-off-by: Baurzhan Ismagulov <ibr@radix50.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/cpm_uart/cpm_uart.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/cpm_uart/cpm_uart.h b/drivers/serial/cpm_uart/cpm_uart.h
index 7274b52..b754dcf 100644
--- a/drivers/serial/cpm_uart/cpm_uart.h
+++ b/drivers/serial/cpm_uart/cpm_uart.h
@@ -76,18 +76,12 @@ struct uart_cpm_port {
 	unsigned char		*tx_buf;
 	unsigned char		*rx_buf;
 	u32			flags;
-	void			(*set_lineif)(struct uart_cpm_port *);
 	struct clk		*clk;
 	u8			brg;
 	uint			 dp_addr;
 	void			*mem_addr;
 	dma_addr_t		 dma_addr;
 	u32			mem_size;
-	/* helpers */
-	int			 baud;
-	int			 bits;
-	/* Keep track of 'odd' SMC2 wirings */
-	int			is_portb;
 	/* wait on close if needed */
 	int			wait_closing;
 	/* value to combine with opcode to form cpm command */
-- 
1.7.3.2

