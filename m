Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab0IXQlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:41:11 -0400
Received: from kroah.org ([198.145.64.141]:37342 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933070Ab0IXQfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:34 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:48 2010
Message-Id: <20100924163347.929212681@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [44/68] AT91: change dma resource index
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 8d2602e0778299e2d6084f03086b716d6e7a1e1e upstream.

Reported-by: Dan Liang <dan.liang@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -46,7 +46,7 @@ static struct resource hdmac_resources[]
 		.end	= AT91_BASE_SYS + AT91_DMA + SZ_512 - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[2] = {
+	[1] = {
 		.start	= AT91SAM9G45_ID_DMA,
 		.end	= AT91SAM9G45_ID_DMA,
 		.flags	= IORESOURCE_IRQ,


