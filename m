Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0KHCm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 21:42:26 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:58888 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab0KHCmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 21:42:25 -0500
X-IronPort-AV: E=Sophos;i="4.58,311,1286164800"; 
   d="scan'208";a="24480646"
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Joe Perches <joe@perches.com>, Mike Frysinger <vapier@gentoo.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 7 Nov 2010 21:45:04 -0500
Subject: RE: [PATCH] drivers/serial/bfin_5xx.c: Fix line continuation defects
Thread-Topic: [PATCH] drivers/serial/bfin_5xx.c: Fix line continuation
 defects
Thread-Index: Act+wDLDzkcsPg+ATd+V0+84S/YvywALjqHA
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16578BD03B2@NWD2CMBX1.ad.analog.com>
References: <1289164223.29216.316.camel@Joe-Laptop>
In-Reply-To: <1289164223.29216.316.camel@Joe-Laptop>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Joe Perches [mailto:joe@perches.com]
>Sent: Monday, November 08, 2010 5:10 AM
>To: Zhang, Sonic; Mike Frysinger; Greg Kroah-Hartman
>Cc: uclinux-dist-devel@blackfin.uclinux.org;
>linux-kernel@vger.kernel.org
>Subject: [PATCH] drivers/serial/bfin_5xx.c: Fix line
>continuation defects
>
>Signed-off-by: Joe Perches <joe@perches.com>


Acked-by: Sonic Zhang <sonic.zhang@analog.com>

Thanks

Sonic Zhang

>---
> drivers/serial/bfin_5xx.c |    6 ++----
> 1 files changed, 2 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/serial/bfin_5xx.c
>b/drivers/serial/bfin_5xx.c index a9eff2b..351cc03 100644
>--- a/drivers/serial/bfin_5xx.c
>+++ b/drivers/serial/bfin_5xx.c
>@@ -734,8 +734,7 @@ static int bfin_serial_startup(struct
>uart_port *port)
>                       IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
>                       IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
>                       uart->cts_pin = -1;
>-                      pr_info("Unable to attach BlackFin UART
>CTS interrupt.\
>-                               So, disable it.\n");
>+                      pr_info("Unable to attach BlackFin UART
>CTS interrupt. So, disable
>+it.\n");
>               }
>       }
>       if (uart->rts_pin >= 0) {
>@@ -747,8 +746,7 @@ static int bfin_serial_startup(struct
>uart_port *port)
>       if (request_irq(uart->status_irq,
>               bfin_serial_mctrl_cts_int,
>               IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
>-              pr_info("Unable to attach BlackFin UART Modem \
>-                      Status interrupt.\n");
>+              pr_info("Unable to attach BlackFin UART Modem
>Status interrupt.\n");
>       }
>
>       /* CTS RTS PINs are negative assertive. */
>
>
>
