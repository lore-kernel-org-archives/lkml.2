Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab0C0C2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:28:49 -0400
Received: from mail.perches.com ([173.55.12.10]:1145 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab0C0C2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:28:04 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 8/9] drivers/serial: Fix continuation lines
Date: Fri, 26 Mar 2010 19:27:57 -0700
Message-Id: <a84509bbf49c6a286c571d8b4f569b4e54aea913.1269655208.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269655208.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/bfin_5xx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index fcf273e..48f1986 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -733,8 +733,8 @@ static int bfin_serial_startup(struct uart_port *port)
 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
 			IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
 			uart->cts_pin = -1;
-			pr_info("Unable to attach BlackFin UART CTS interrupt.\
-				 So, disable it.\n");
+			pr_info("Unable to attach BlackFin UART CTS interrupt."
+				" So, disable it.\n");
 		}
 	}
 	if (uart->rts_pin >= 0) {
@@ -746,8 +746,8 @@ static int bfin_serial_startup(struct uart_port *port)
 	if (request_irq(uart->status_irq,
 		bfin_serial_mctrl_cts_int,
 		IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
-		pr_info("Unable to attach BlackFin UART Modem \
-			Status interrupt.\n");
+		pr_info("Unable to attach BlackFin UART Modem "
+			"Status interrupt.\n");
 	}
 
 	/* CTS RTS PINs are negative assertive. */
-- 
1.7.0.14.g7e948

