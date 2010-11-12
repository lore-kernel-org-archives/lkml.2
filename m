Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab0KLVnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:43:53 -0500
Received: from kroah.org ([198.145.64.141]:41595 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055Ab0KLVlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/19] drivers/serial/bfin_5xx.c: Fix line continuation defects
Date: Fri, 12 Nov 2010 13:40:54 -0800
Message-Id: <1289598066-10112-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_5xx.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index a9eff2b..351cc03 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -734,8 +734,7 @@ static int bfin_serial_startup(struct uart_port *port)
 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
 			IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
 			uart->cts_pin = -1;
-			pr_info("Unable to attach BlackFin UART CTS interrupt.\
-				 So, disable it.\n");
+			pr_info("Unable to attach BlackFin UART CTS interrupt. So, disable it.\n");
 		}
 	}
 	if (uart->rts_pin >= 0) {
@@ -747,8 +746,7 @@ static int bfin_serial_startup(struct uart_port *port)
 	if (request_irq(uart->status_irq,
 		bfin_serial_mctrl_cts_int,
 		IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
-		pr_info("Unable to attach BlackFin UART Modem \
-			Status interrupt.\n");
+		pr_info("Unable to attach BlackFin UART Modem Status interrupt.\n");
 	}
 
 	/* CTS RTS PINs are negative assertive. */
-- 
1.7.1

