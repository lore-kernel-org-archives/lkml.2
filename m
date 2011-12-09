Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1LIWlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:41:07 -0500
Received: from the.earth.li ([46.43.34.31]:44727 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab1LIWlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:41:03 -0500
X-Greylist: delayed 2483 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Dec 2011 17:41:01 EST
Date: Fri, 9 Dec 2011 13:59:29 -0800
From: Jonathan McDowell <noodles@earth.li>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Imre Deak <imre.deak@nokia.com>,
        Cory Maccarrone <darkstar6262@gmail.com>,
        Laurent Gonzalez <palmte.linux@free.fr>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] video: omap: Staticise non-exported symbols
Message-ID: <20111209215929.GF16333@earth.li>
References: <1323394677.3740.2.camel@phoenix>
 <201112090923.46643.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112090923.46643.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 09:23:46AM +0100, Marek Vasut wrote:
> > These symbols are not used outside it's driver so no need to
> > make the symbol global.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  drivers/video/omap/lcd_ams_delta.c |    2 +-
> >  drivers/video/omap/lcd_h3.c        |    2 +-
> >  drivers/video/omap/lcd_htcherald.c |    2 +-
> >  drivers/video/omap/lcd_inn1510.c   |    2 +-
> >  drivers/video/omap/lcd_inn1610.c   |    2 +-
> >  drivers/video/omap/lcd_osk.c       |    2 +-
> >  drivers/video/omap/lcd_palmte.c    |    2 +-
> >  drivers/video/omap/lcd_palmtt.c    |    2 +-
> >  drivers/video/omap/lcd_palmz71.c   |    2 +-
> >  9 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/video/omap/lcd_ams_delta.c
> > b/drivers/video/omap/lcd_ams_delta.c index 6978ae4..eb50a95 100644
> > --- a/drivers/video/omap/lcd_ams_delta.c
> > +++ b/drivers/video/omap/lcd_ams_delta.c
> > @@ -198,7 +198,7 @@ static int ams_delta_panel_resume(struct
> > platform_device *pdev) return 0;
> >  }
> > 
> > -struct platform_driver ams_delta_panel_driver = {
> > +static struct platform_driver ams_delta_panel_driver = {
> >  	.probe		= ams_delta_panel_probe,
> >  	.remove		= ams_delta_panel_remove,
> >  	.suspend	= ams_delta_panel_suspend,
> > diff --git a/drivers/video/omap/lcd_h3.c b/drivers/video/omap/lcd_h3.c
> > index 622ad83..baec34e 100644
> > --- a/drivers/video/omap/lcd_h3.c
> > +++ b/drivers/video/omap/lcd_h3.c
> > @@ -113,7 +113,7 @@ static int h3_panel_resume(struct platform_device
> > *pdev) return 0;
> >  }
> > 
> > -struct platform_driver h3_panel_driver = {
> > +static struct platform_driver h3_panel_driver = {
> >  	.probe		= h3_panel_probe,
> >  	.remove		= h3_panel_remove,
> >  	.suspend	= h3_panel_suspend,
> > diff --git a/drivers/video/omap/lcd_htcherald.c
> > b/drivers/video/omap/lcd_htcherald.c index 4802419..b1a022f 100644
> > --- a/drivers/video/omap/lcd_htcherald.c
> > +++ b/drivers/video/omap/lcd_htcherald.c
> > @@ -104,7 +104,7 @@ static int htcherald_panel_resume(struct
> > platform_device *pdev) return 0;
> >  }
> > 
> > -struct platform_driver htcherald_panel_driver = {
> > +static struct platform_driver htcherald_panel_driver = {
> >  	.probe		= htcherald_panel_probe,
> >  	.remove		= htcherald_panel_remove,
> >  	.suspend	= htcherald_panel_suspend,
> > diff --git a/drivers/video/omap/lcd_inn1510.c
> > b/drivers/video/omap/lcd_inn1510.c index 3271f16..d129946 100644
> > --- a/drivers/video/omap/lcd_inn1510.c
> > +++ b/drivers/video/omap/lcd_inn1510.c
> > @@ -98,7 +98,7 @@ static int innovator1510_panel_resume(struct
> > platform_device *pdev) return 0;
> >  }
> > 
> > -struct platform_driver innovator1510_panel_driver = {
> > +static struct platform_driver innovator1510_panel_driver = {
> >  	.probe		= innovator1510_panel_probe,
> >  	.remove		= innovator1510_panel_remove,
> >  	.suspend	= innovator1510_panel_suspend,
> > diff --git a/drivers/video/omap/lcd_inn1610.c
> > b/drivers/video/omap/lcd_inn1610.c index 12cc52a..a95756b 100644
> > --- a/drivers/video/omap/lcd_inn1610.c
> > +++ b/drivers/video/omap/lcd_inn1610.c
> > @@ -122,7 +122,7 @@ static int innovator1610_panel_resume(struct
> > platform_device *pdev) return 0;
> >  }
> > 
> > -struct platform_driver innovator1610_panel_driver = {
> > +static struct platform_driver innovator1610_panel_driver = {
> >  	.probe		= innovator1610_panel_probe,
> >  	.remove		= innovator1610_panel_remove,
> >  	.suspend	= innovator1610_panel_suspend,
> > diff --git a/drivers/video/omap/lcd_osk.c b/drivers/video/omap/lcd_osk.c
> > index 6f8d13c..b985997 100644
> > --- a/drivers/video/omap/lcd_osk.c
> > +++ b/drivers/video/omap/lcd_osk.c
> > @@ -116,7 +116,7 @@ static int osk_panel_resume(struct platform_device
> > *pdev) return 0;
> >  }
> > 
> > -struct platform_driver osk_panel_driver = {
> > +static struct platform_driver osk_panel_driver = {
> >  	.probe		= osk_panel_probe,
> >  	.remove		= osk_panel_remove,
> >  	.suspend	= osk_panel_suspend,
> > diff --git a/drivers/video/omap/lcd_palmte.c
> > b/drivers/video/omap/lcd_palmte.c index 4cb3017..d79f436 100644
> > --- a/drivers/video/omap/lcd_palmte.c
> > +++ b/drivers/video/omap/lcd_palmte.c
> > @@ -97,7 +97,7 @@ static int palmte_panel_resume(struct platform_device
> > *pdev) return 0;
> >  }
> > 
> > -struct platform_driver palmte_panel_driver = {
> > +static struct platform_driver palmte_panel_driver = {
> >  	.probe		= palmte_panel_probe,
> >  	.remove		= palmte_panel_remove,
> >  	.suspend	= palmte_panel_suspend,
> > diff --git a/drivers/video/omap/lcd_palmtt.c
> > b/drivers/video/omap/lcd_palmtt.c index b51b332..c2e96a7 100644
> > --- a/drivers/video/omap/lcd_palmtt.c
> > +++ b/drivers/video/omap/lcd_palmtt.c
> > @@ -102,7 +102,7 @@ static int palmtt_panel_resume(struct platform_device
> > *pdev) return 0;
> >  }
> > 
> > -struct platform_driver palmtt_panel_driver = {
> > +static struct platform_driver palmtt_panel_driver = {
> >  	.probe		= palmtt_panel_probe,
> >  	.remove		= palmtt_panel_remove,
> >  	.suspend	= palmtt_panel_suspend,
> > diff --git a/drivers/video/omap/lcd_palmz71.c
> > b/drivers/video/omap/lcd_palmz71.c index 2334e56..1ab4847 100644
> > --- a/drivers/video/omap/lcd_palmz71.c
> > +++ b/drivers/video/omap/lcd_palmz71.c
> > @@ -98,7 +98,7 @@ static int palmz71_panel_resume(struct platform_device
> > *pdev) return 0;
> >  }
> > 
> > -struct platform_driver palmz71_panel_driver = {
> > +static struct platform_driver palmz71_panel_driver = {
> >  	.probe		= palmz71_panel_probe,
> >  	.remove		= palmz71_panel_remove,
> >  	.suspend	= palmz71_panel_suspend,
> 
> I can speak for palmtt and palmz71,
> 
> Acked-by: Marek Vasut <marek.vasut@gmail.com>

Likewise, for ams-delta,

Acked-By: Jonathan McDowell <noodles@earth.li>

J.

-- 
Generally, all generalizations are false..
This .sig brought to you by the letter Z and the number 26
Product of the Republic of HuggieTag
