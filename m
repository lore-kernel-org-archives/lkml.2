Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab0IJKTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:19:14 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:51651 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751028Ab0IJKTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:19:13 -0400
Date: Fri, 10 Sep 2010 12:18:16 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com
Subject: Re: [PATCH] AT91: dm9000 initialization update
Message-ID: <20100910101816.GP9112@game.jcrosoft.org>
References: <1284113629-13768-1-git-send-email-nicolas.ferre@atmel.com>
 <20100910092344.GN9112@game.jcrosoft.org>
 <4C89FFAA.3010503@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C89FFAA.3010503@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 448952588618541932
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:51 Fri 10 Sep     , Nicolas Ferre wrote:
> Le 10/09/2010 11:23, Jean-Christophe PLAGNIOL-VILLARD :
> > On 12:13 Fri 10 Sep     , Nicolas Ferre wrote:
> >> Add information in dm9000 mac/phy chip initialization:
> >> - irq resource details
> >> - platform data details
> >>
> >> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >> ---
> >>  arch/arm/mach-at91/board-sam9261ek.c |    3 ++-
> >>  1 files changed, 2 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
> >> index c4c8865..b4307ab 100644
> >> --- a/arch/arm/mach-at91/board-sam9261ek.c
> >> +++ b/arch/arm/mach-at91/board-sam9261ek.c
> >> @@ -93,11 +93,12 @@ static struct resource dm9000_resource[] = {
> >>  		.start	= AT91_PIN_PC11,
> >>  		.end	= AT91_PIN_PC11,
> >>  		.flags	= IORESOURCE_IRQ
> >> +			| IORESOURCE_IRQ_LOWEDGE | IORESOURCE_IRQ_HIGHEDGE,
> > both?
> 
> Yes, only configuration supported by GPIO irqs...
ok fine

Best Regards,
J.
