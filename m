Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1LGMun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:50:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58406 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab1LGMum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:50:42 -0500
Date: Wed, 7 Dec 2011 13:50:29 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Shawn Guo <shawn.guo@freescale.com>, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Subject: Re: [MXS MMC 2/5] Some cleanups for the MMC driver
Message-ID: <20111207125029.GJ4585@pengutronix.de>
References: <cover.1323177907.git.LW@KARO-electronics.de>
 <d935557e044d2ebc56b4e70487b519fe722e9017.1323177907.git.LW@KARO-electronics.de>
 <20111207120120.GK5550@S2100-06.ap.freescale.net>
 <20191.21688.696997.76000@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191.21688.696997.76000@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 12:57:44PM +0100, Lothar Waßmann wrote:
> Hi,
> 
> Shawn Guo writes:
> > I'm fine with this cosmetic patch with the comments below addressed.
> > 
> > On Tue, Dec 06, 2011 at 02:41:27PM +0100, Lothar Waßmann wrote:
> > >  - Remove bogus parens around numerical arguments in #define's
> > >  - When defining bit masks, use the #def for the shift count
> > >    instead of repeating the numbers
> > 
> > This change brings a few 'line over 80 characters' checkpatch warnings.
> > 
> will fix.
> 
> > >  - Remove bogus whitespace in indentation
> > >  - Remove 'break' at end of switch statement
> > > 
> > > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > > ---
> > >  drivers/mmc/host/mxs-mmc.c |   57 +++++++++++++++++++++----------------------
> > >  1 files changed, 28 insertions(+), 29 deletions(-)
> > > 
> > > diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> > [...]
> > > @@ -277,7 +277,7 @@ static irqreturn_t mxs_mmc_irq_handler(int irq, void *dev_id)
> > >  
> > >  	stat = readl(host->base + HW_SSP_CTRL1);
> > >  	writel(stat & MXS_MMC_IRQ_BITS,
> > > -	       host->base + HW_SSP_CTRL1 + MXS_CLR_ADDR);
> > 
> > This is an intended indentation with 7 spaces.
> > 
> According to Documentation/CodingStyle spaces are never used for
> indentation (except in documentation, Kconfig and comments).
AFAIK "don't use spaces" only applies to the first line of a statement.
When breaking long lines using spaces to align to the containing
parenthesis is quite common (though I don't like it personally).

The rule for follow-up lines is only: Descendants are always
substantially shorter than the parent and are placed substantially to
the right.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
