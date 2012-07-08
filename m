Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab2GHTw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 15:52:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45315 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2GHTw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 15:52:57 -0400
Date: Sun, 8 Jul 2012 21:52:46 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Philippe Reynes <tremyfr@yahoo.fr>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Add nand platform on imx27 devicetree
Message-ID: <20120708195246.GF4687@pengutronix.de>
References: <1341764963-11402-1-git-send-email-tremyfr@yahoo.fr>
 <CAOMZO5BjcnB=CJ=i=V7Ct9oMvgnnbK8AjWvYJZdoVmZu=+_MQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5BjcnB=CJ=i=V7Ct9oMvgnnbK8AjWvYJZdoVmZu=+_MQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 08, 2012 at 01:57:37PM -0300, Fabio Estevam wrote:
> On Sun, Jul 8, 2012 at 1:29 PM, Philippe Reynes <tremyfr@yahoo.fr> wrote:
> > Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
> > ---
> >  arch/arm/mach-imx/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> > index eff4db5..565422b 100644
> > --- a/arch/arm/mach-imx/Kconfig
> > +++ b/arch/arm/mach-imx/Kconfig
> > @@ -381,6 +381,7 @@ config MACH_IMX27_DT
> >         bool "Support i.MX27 platforms from device tree"
> >         select SOC_IMX27
> >         select USE_OF
> > +       select IMX_HAVE_PLATFORM_MXC_NAND
> 
> Bu doing this you end up selecting unnecessary code for dt.
> 
> I proposed a fix for this already:
> http://patchwork.ozlabs.org/patch/168645/
I only know understood your explaination why you don't want this patch
instead. So ok, I prefer your patch, too.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
