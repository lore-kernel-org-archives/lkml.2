Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2KDK5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 05:57:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52434 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2KDK5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 05:57:07 -0500
Date: Sun, 4 Nov 2012 11:57:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/9] ARM: at91: Remove unused struct
 at91sam9g45_isi_device and its resources
Message-ID: <20121104105702.GD27124@gmail.com>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
 <1351980150-24145-3-git-send-email-lee.jones@linaro.org>
 <20121104101502.GI19021@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121104101502.GI19021@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Nov 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 23:02 Sat 03 Nov     , Lee Jones wrote:
> > This the at91sam9g45_isi_device structure and its associated resources
> > were added in 2008 and have been unused ever since. Let's remove them.
> next time you need to Cc the matinaers

I did:

$ git show <sha1> | scripts/get_maintainer.pl
  Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT)
  linux-arm-kernel@lists.infradead.org (moderated list:ARM SUB-ARCHITECT...)
  linux-kernel@vger.kernel.org (open list)

> NACK

Any particular reason?

> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/mach-at91/at91sam9263_devices.c |   20 --------------------
> >  1 file changed, 20 deletions(-)
> > 
> > diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
> > index cb85da2..0562a9d 100644
> > --- a/arch/arm/mach-at91/at91sam9263_devices.c
> > +++ b/arch/arm/mach-at91/at91sam9263_devices.c
> > @@ -901,26 +901,6 @@ void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data) {}
> >  
> >  #if defined(CONFIG_VIDEO_AT91_ISI) || defined(CONFIG_VIDEO_AT91_ISI_MODULE)
> >  
> > -struct resource isi_resources[] = {
> > -	[0] = {
> > -		.start	= AT91SAM9263_BASE_ISI,
> > -		.end	= AT91SAM9263_BASE_ISI + SZ_16K - 1,
> > -		.flags	= IORESOURCE_MEM,
> > -	},
> > -	[1] = {
> > -		.start	= NR_IRQS_LEGACY + AT91SAM9263_ID_ISI,
> > -		.end	= NR_IRQS_LEGACY + AT91SAM9263_ID_ISI,
> > -		.flags	= IORESOURCE_IRQ,
> > -	},
> > -};
> > -
> > -static struct platform_device at91sam9263_isi_device = {
> > -	.name		= "at91_isi",
> > -	.id		= -1,
> > -	.resource	= isi_resources,
> > -	.num_resources	= ARRAY_SIZE(isi_resources),
> > -};
> > -
> >  void __init at91_add_device_isi(struct isi_platform_data *data,
> >  		bool use_pck_as_mck)
> >  {
> > -- 
> > 1.7.9.5
> > 
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
