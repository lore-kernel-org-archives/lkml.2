Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0HXCfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:35:46 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:15298 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0HXCfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:35:43 -0400
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.56,260,1280721600"; 
   d="scan'208";a="21136633"
Content-Class: urn:content-classes:message
Subject: RE: [PATCH 1/2] drivers/serial/bfin_5xx.c: Fix logging messages continued with \
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Aug 2010 10:37:02 +0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA06C359EF@chinexm1.ad.analog.com>
In-Reply-To: <6028a858f4eb3f07cc5cdddebf5af64fb0e6204e.1282589920.git.joe@perches.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] drivers/serial/bfin_5xx.c: Fix logging messages continued with \
Thread-Index: ActC9aYW5XQZKY0BSv2jJsionKwvAAAPv+xQ
References: <6028a858f4eb3f07cc5cdddebf5af64fb0e6204e.1282589920.git.joe@perches.com>
To: "Joe Perches" <joe@perches.com>, <linux-kernel@vger.kernel.org>
CC: <uclinux-dist-devel@blackfin.uclinux.org>
X-OriginalArrivalTime: 24 Aug 2010 02:35:33.0161 (UTC) FILETIME=[06809990:01CB4335]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Joe Perches [mailto:joe@perches.com] 
>Sent: Tuesday, August 24, 2010 3:02 AM
>To: linux-kernel@vger.kernel.org
>Cc: Zhang, Sonic; uclinux-dist-devel@blackfin.uclinux.org
>Subject: [PATCH 1/2] drivers/serial/bfin_5xx.c: Fix logging 
>messages continued with \
>
>Using continuation lines often introduces undesired whitespace.
>Fix the misuses.
>

Acked-by: Sonic Zhang <sonic.zhang@analog.com>


>Signed-off-by: Joe Perches <joe@perches.com>
>---
> drivers/serial/bfin_5xx.c |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/serial/bfin_5xx.c 
>b/drivers/serial/bfin_5xx.c index a9eff2b..4e38f99 100644
>--- a/drivers/serial/bfin_5xx.c
>+++ b/drivers/serial/bfin_5xx.c
>@@ -734,8 +734,8 @@ static int bfin_serial_startup(struct 
>uart_port *port)
> 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
> 			IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
> 			uart->cts_pin = -1;
>-			pr_info("Unable to attach BlackFin UART 
>CTS interrupt.\
>-				 So, disable it.\n");
>+			pr_info("Unable to attach BlackFin UART 
>CTS interrupt. "
>+				"So, disable it.\n");
> 		}
> 	}
> 	if (uart->rts_pin >= 0) {
>@@ -747,8 +747,8 @@ static int bfin_serial_startup(struct 
>uart_port *port)
> 	if (request_irq(uart->status_irq,
> 		bfin_serial_mctrl_cts_int,
> 		IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
>-		pr_info("Unable to attach BlackFin UART Modem \
>-			Status interrupt.\n");
>+		pr_info("Unable to attach BlackFin UART Modem "
>+			"Status interrupt.\n");
> 	}
> 
> 	/* CTS RTS PINs are negative assertive. */
>--
>1.7.2.19.g9a302
>
>
