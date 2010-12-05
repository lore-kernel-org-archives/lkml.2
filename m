Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0LECwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 21:52:05 -0500
Received: from void.printf.net ([89.145.121.20]:49610 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab0LECwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 21:52:03 -0500
Date: Sun, 5 Dec 2010 02:51:51 +0000
From: Chris Ball <cjb@laptop.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 4/4] [ARM] mxcmmc: remove a unnecessary
	release_resource() call
Message-ID: <20101205025150.GA24000@void.printf.net>
References: <1290415359.5471.4.camel@mola> <1290415467.5471.7.camel@mola> <1290415534.5471.8.camel@mola> <1290415596.5471.10.camel@mola> <1290415671.5471.13.camel@mola> <20101125090311.GP6017@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125090311.GP6017@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 25, 2010 at 10:03:11AM +0100, Sascha Hauer wrote:
> On Mon, Nov 22, 2010 at 04:47:51PM +0800, Axel Lin wrote:
> > Remove release_resource() after release_mem_region().
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> > ---
> >  drivers/mmc/host/mxcmmc.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
> > index 2b9f7c8..4428594 100644
> > --- a/drivers/mmc/host/mxcmmc.c
> > +++ b/drivers/mmc/host/mxcmmc.c
> > @@ -967,7 +967,6 @@ static int mxcmci_remove(struct platform_device *pdev)
> >  	clk_put(host->clk);
> >  
> >  	release_mem_region(host->res->start, resource_size(host->res));
> > -	release_resource(host->res);
> >  
> >  	mmc_free_host(mmc);
> >  

Pushed to mmc-next for .38, thanks.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
