Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0GEIIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:08:01 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:64475 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0GEIH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:07:59 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18knV6VuUVJlodDpRLubeCr
Date: Mon, 5 Jul 2010 11:07:59 +0300
From: Tony Lindgren <tony@atomide.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Christoph Egger <siccegge@cs.fau.de>,
       Russell King <linux@arm.linux.org.uk>,
       Cory Maccarrone <darkstar6262@gmail.com>,
       "Zebediah C. McClure" <zmc@lurian.net>,
       Alistair Buxton <a.j.buxton@gmail.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 03/33] Removing dead OMAP_MUX_ERRORS
Message-ID: <20100705080757.GC15951@atomide.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <b6ca168f9459162f2c96aa8ef999047a3c4f6f9c.1277911346.git.siccegge@cs.fau.de>
 <20100630195409.GC3969@shutemov.name>
 <20100701132255.GA32541@faui48a.informatik.uni-erlangen.de>
 <20100701152743.GA8588@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701152743.GA8588@shutemov.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill A. Shutemov <kirill@shutemov.name> [100701 18:21]:
> On Thu, Jul 01, 2010 at 03:22:55PM +0200, Christoph Egger wrote:
> > On Wed, Jun 30, 2010 at 10:54:09PM +0300, Kirill A. Shutemov wrote:
> > > On Wed, Jun 30, 2010 at 05:54:42PM +0200, Christoph Egger wrote:
> > > > OMAP_MUX_ERRORS doesn't exist in Kconfig, therefore removing all
> > > > references for it from the source code.
> > > 
> > > IIUC, CONFIG_OMAP_MUX_WARNINGS should be used here instead of it.
> > 
> > Something like the patch below?
> 
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

Thanks, I've queued up this.

Tony
 
> > 
> > ----
> > From: Christoph Egger <siccegge@cs.fau.de>
> > Date: Wed, 30 Jun 2010 12:30:36 +0200
> > Subject: [PATCH 03/33] Replace dead OMAP_MUX_ERRORS with OMAP_MUX_WARNINGS
> > 
> > OMAP_MUX_ERRORS doesn't exist in Kconfig, therefore replacing all
> > references for it with OMAP_MUX_WARNINGS in the source code.
> > 
> > Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> > ---
> >  arch/arm/mach-omap1/mux.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap1/mux.c b/arch/arm/mach-omap1/mux.c
> > index 8434137..3e98835 100644
> > --- a/arch/arm/mach-omap1/mux.c
> > +++ b/arch/arm/mach-omap1/mux.c
> > @@ -440,7 +440,7 @@ int __init_or_module omap1_cfg_reg(const struct pin_config *cfg)
> >  	}
> >  #endif
> >  
> > -#ifdef CONFIG_OMAP_MUX_ERRORS
> > +#ifdef CONFIG_OMAP_MUX_WARNINGS
> >  	return warn ? -ETXTBSY : 0;
> >  #else
> >  	return 0;
> > -- 
> > 1.7.0.4
> > 
> > 
> 
> -- 
>  Kirill A. Shutemov
