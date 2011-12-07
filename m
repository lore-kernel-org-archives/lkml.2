Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1LGMDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:03:21 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:17010 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab1LGMDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:03:19 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 7 Dec 2011 20:16:04 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <linux-arm-kernel@lists.infradead.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>
Subject: Re: [MXS MMC 2/5] Some cleanups for the MMC driver
Message-ID: <20111207121603.GL5550@S2100-06.ap.freescale.net>
References: <cover.1323177907.git.LW@KARO-electronics.de>
 <d935557e044d2ebc56b4e70487b519fe722e9017.1323177907.git.LW@KARO-electronics.de>
 <20111207120120.GK5550@S2100-06.ap.freescale.net>
 <20191.21688.696997.76000@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20191.21688.696997.76000@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 12:57:44PM +0100, Lothar Waﬂmann wrote:
> Hi,
> 
> Shawn Guo writes:
> > I'm fine with this cosmetic patch with the comments below addressed.
> > 
> > On Tue, Dec 06, 2011 at 02:41:27PM +0100, Lothar Waﬂmann wrote:
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
> > > Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
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
> 
Such nice indentation is all over this driver and even kernel tree.
You may want to leave it as it is or fix them all over the driver.

-- 
Regards,
Shawn

