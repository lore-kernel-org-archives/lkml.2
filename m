Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532Ab0EURI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:08:59 -0400
Received: from kroah.org ([198.145.64.141]:50284 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934056Ab0EUQv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:51:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/25] serial: bfin_sport_uart: remove unused peripheral pin lists
Date: Fri, 21 May 2010 09:51:32 -0700
Message-Id: <1274460714-11277-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

All the resources are in the boards files now.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 6991c36..5dcf5dc 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -39,27 +39,6 @@
 
 #include "bfin_sport_uart.h"
 
-#ifdef CONFIG_SERIAL_BFIN_SPORT0_UART
-unsigned short bfin_uart_pin_req_sport0[] =
-	{P_SPORT0_TFS, P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS, \
-	 P_SPORT0_DRPRI, P_SPORT0_RSCLK, P_SPORT0_DRSEC, P_SPORT0_DTSEC, 0};
-#endif
-#ifdef CONFIG_SERIAL_BFIN_SPORT1_UART
-unsigned short bfin_uart_pin_req_sport1[] =
-	{P_SPORT1_TFS, P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_RFS, \
-	P_SPORT1_DRPRI, P_SPORT1_RSCLK, P_SPORT1_DRSEC, P_SPORT1_DTSEC, 0};
-#endif
-#ifdef CONFIG_SERIAL_BFIN_SPORT2_UART
-unsigned short bfin_uart_pin_req_sport2[] =
-	{P_SPORT2_TFS, P_SPORT2_DTPRI, P_SPORT2_TSCLK, P_SPORT2_RFS, \
-	P_SPORT2_DRPRI, P_SPORT2_RSCLK, P_SPORT2_DRSEC, P_SPORT2_DTSEC, 0};
-#endif
-#ifdef CONFIG_SERIAL_BFIN_SPORT3_UART
-unsigned short bfin_uart_pin_req_sport3[] =
-	{P_SPORT3_TFS, P_SPORT3_DTPRI, P_SPORT3_TSCLK, P_SPORT3_RFS, \
-	P_SPORT3_DRPRI, P_SPORT3_RSCLK, P_SPORT3_DRSEC, P_SPORT3_DTSEC, 0};
-#endif
-
 struct sport_uart_port {
 	struct uart_port	port;
 	int			err_irq;
-- 
1.7.0.3

