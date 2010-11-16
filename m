Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab0KPO2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:28:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933432Ab0KPO21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:28:27 -0500
Date: Tue, 16 Nov 2010 06:09:47 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Josh Wu <josh.wu@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH TRIVIAL] AT91: usb: fix typo in atmel_usba_udc driver
Message-ID: <20101116140947.GA15097@suse.de>
References: <1289902493-1821-1-git-send-email-josh.wu@atmel.com> <alpine.LNX.2.00.1011161149460.7420@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011161149460.7420@pobox.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:51:32AM +0100, Jiri Kosina wrote:
> On Tue, 16 Nov 2010, Josh Wu wrote:
> 
> > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > ---
> > fix against 2.6.37-rc1
> > 
> >  drivers/usb/gadget/atmel_usba_udc.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> > index b5e20e8..717ff65 100644
> > --- a/drivers/usb/gadget/atmel_usba_udc.c
> > +++ b/drivers/usb/gadget/atmel_usba_udc.c
> > @@ -2017,7 +2017,7 @@ static int __init usba_udc_probe(struct platform_device *pdev)
> >  			}
> >  		} else {
> >  			/* gpio_request fail so use -EINVAL for gpio_is_valid */
> > -			ubc->vbus_pin = -EINVAL;
> > +			udc->vbus_pin = -EINVAL;
> >  		}
> >  	}
> >  
> 
> As this is a compile fix (for bug introduced by 969affff547027), I am 
> adding Greg and linux-usb@ to CC. I usually don't push trivial changes 
> more than once per release, but this needs to go in faster.
> 
> Greg, could you please take it?

Yes, I will take it.

thanks,

greg k-h
