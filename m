Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab1LGL6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:58:09 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:60263 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab1LGL6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:58:08 -0500
Message-ID: <20191.21688.696997.76000@ipc1.ka-ro>
Date: Wed, 7 Dec 2011 12:57:44 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: <linux-arm-kernel@lists.infradead.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [MXS MMC 2/5] Some cleanups for the MMC driver
In-Reply-To: <20111207120120.GK5550@S2100-06.ap.freescale.net>
References: <cover.1323177907.git.LW@KARO-electronics.de>
	<d935557e044d2ebc56b4e70487b519fe722e9017.1323177907.git.LW@KARO-electronics.de>
	<20111207120120.GK5550@S2100-06.ap.freescale.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Shawn Guo writes:
> I'm fine with this cosmetic patch with the comments below addressed.
> 
> On Tue, Dec 06, 2011 at 02:41:27PM +0100, Lothar Waßmann wrote:
> >  - Remove bogus parens around numerical arguments in #define's
> >  - When defining bit masks, use the #def for the shift count
> >    instead of repeating the numbers
> 
> This change brings a few 'line over 80 characters' checkpatch warnings.
> 
will fix.

> >  - Remove bogus whitespace in indentation
> >  - Remove 'break' at end of switch statement
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > ---
> >  drivers/mmc/host/mxs-mmc.c |   57 +++++++++++++++++++++----------------------
> >  1 files changed, 28 insertions(+), 29 deletions(-)
> > 
> > diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> [...]
> > @@ -277,7 +277,7 @@ static irqreturn_t mxs_mmc_irq_handler(int irq, void *dev_id)
> >  
> >  	stat = readl(host->base + HW_SSP_CTRL1);
> >  	writel(stat & MXS_MMC_IRQ_BITS,
> > -	       host->base + HW_SSP_CTRL1 + MXS_CLR_ADDR);
> 
> This is an intended indentation with 7 spaces.
> 
According to Documentation/CodingStyle spaces are never used for
indentation (except in documentation, Kconfig and comments).


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
