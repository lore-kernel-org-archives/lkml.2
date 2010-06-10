Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab0FJBzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:55:16 -0400
Received: from mail.perches.com ([173.55.12.10]:2981 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab0FJBzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:55:14 -0400
Subject: Re: [PATCH 02/12] MAINTAINERS: Update ARM/NUVOTON W90X900 ARM 
 ARCHITECTURE file patterns
From: Joe Perches <joe@perches.com>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <AANLkTinXm_hO--jxGhHDnTsW_93uuqR4S5-HTzXU1Hvj@mail.gmail.com>
References: <cover.1276112117.git.joe@perches.com>
	 <6d429f15de979525b295a490c68004a9ac2551a0.1276112117.git.joe@perches.com>
	 <AANLkTinXm_hO--jxGhHDnTsW_93uuqR4S5-HTzXU1Hvj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 18:55:11 -0700
Message-ID: <1276134911.1556.228.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 09:47 +0800, Wan ZongShun wrote:
> Hi Joe,

Hi.

> 2010/6/10 Joe Perches <joe@perches.com>:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > Cc:  Wan ZongShun <mcuos.com@gmail.com>
> > ---
> >  MAINTAINERS |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 2af46b6..9046e97 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -974,12 +974,11 @@ F:        drivers/input/keyboard/w90p910_keypad.c
> >  F:     drivers/input/touchscreen/w90p910_ts.c
> >  F:     drivers/watchdog/nuc900_wdt.c
> >  F:     drivers/net/arm/w90p910_ether.c
> > -F:     drivers/mtd/nand/w90p910_nand.c
> > +F:     drivers/mtd/nand/nuc900_nand.c
> >  F:     drivers/rtc/rtc-nuc900.c
> >  F:     drivers/spi/spi_nuc900.c
> >  F:     drivers/usb/host/ehci-w90x900.c
> >  F:     drivers/video/nuc900fb.c
> > -F:     drivers/sound/soc/nuc900/
> 
> The NUC900 audio driver has been applied by Mark.
> It seems not to have been merged into mainline tree yet.

I presume when it does it should be in
sound/soc/ not drivers/sound/soc

cheers, Joe

