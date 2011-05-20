Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935563Ab1ETKWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 06:22:35 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:39983 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab1ETKWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 06:22:34 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz154dM1432N98dKzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 20 May 2011 18:27:02 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <patches@linaro.org>,
        <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH 1/3] ARM: mxs: remove gpio driver from mach-mxs
Message-ID: <20110520102701.GE27251@S2100-06.ap.freescale.net>
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org>
 <1305885446-27404-2-git-send-email-shawn.guo@linaro.org>
 <201105201204.59237.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201105201204.59237.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 12:04:59PM +0200, Arnd Bergmann wrote:
> On Friday 20 May 2011 11:57:24 Shawn Guo wrote:
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> >  arch/arm/mach-mxs/Makefile       |    2 +-
> >  arch/arm/mach-mxs/gpio.c         |  331 --------------------------------------
> >  arch/arm/mach-mxs/gpio.h         |   34 ----
> >  arch/arm/mach-mxs/mach-mx28evk.c |    1 -
> >  arch/arm/mach-mxs/mm-mx23.c      |    1 -
> >  arch/arm/mach-mxs/mm-mx28.c      |    1 -
> >  6 files changed, 1 insertions(+), 369 deletions(-)
> >  delete mode 100644 arch/arm/mach-mxs/gpio.c
> >  delete mode 100644 arch/arm/mach-mxs/gpio.h
> 
> The patch looks good (removing stuff often is), but
> you are missing a changelog. Please explain why it's
> not used any more so that people can find it later
> when they only look at git but not at your original
> mail 0/3 or the entire series.
> 
That's right.  Will do.

-- 
Regards,
Shawn

