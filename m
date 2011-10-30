Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695Ab1J3Jju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 05:39:50 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:60690 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932481Ab1J3Jjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 05:39:49 -0400
X-Greylist: delayed 809 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Oct 2011 05:39:49 EDT
X-ClientAddr: 85.127.182.195
Date: Sun, 30 Oct 2011 10:23:31 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] [TRIVIAL] ARM: pxa: Fix typo
 'CONFIG_BACKLIGHT_PWM__MODULE'
Message-ID: <20111030102331.682dfd6e@absol.kitzblitz>
In-Reply-To: <201110300035.27985.marek.vasut@gmail.com>
References: <1318347115.5754.3.camel@x61.thuisdomein>
	<alpine.LNX.2.00.1110292127320.3541@pobox.suse.cz>
	<201110300035.27985.marek.vasut@gmail.com>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: p9U9NXWd015892
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Vasut <marek.vasut@gmail.com>:
> > On Tue, 11 Oct 2011, Paul Bolle wrote:
> > > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > > ---
> > > Untested (I don't think I've got the hardware, nor have I got the
> > > toolchain at hand, etc.).
> > > 
> > >  arch/arm/mach-pxa/colibri-pxa270-income.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/arch/arm/mach-pxa/colibri-pxa270-income.c
> > > b/arch/arm/mach-pxa/colibri-pxa270-income.c index 80538b8..248804b
> > > 100644
> > > --- a/arch/arm/mach-pxa/colibri-pxa270-income.c
> > > +++ b/arch/arm/mach-pxa/colibri-pxa270-income.c
> > > @@ -183,7 +183,7 @@ static inline void income_lcd_init(void) {}
> > > 
> > >  /***********************************************************************
> > >  *******
> > >  
> > >   * Backlight
> > >   ***********************************************************************
> > >   *******/
> > > 
> > > -#if defined(CONFIG_BACKLIGHT_PWM) ||
> > > defined(CONFIG_BACKLIGHT_PWM__MODULE) +#if defined(CONFIG_BACKLIGHT_PWM)
> > > || defined(CONFIG_BACKLIGHT_PWM_MODULE)
> > > 
> > >  static struct platform_pwm_backlight_data income_backlight_data = {
> > >  
> > >  	.pwm_id		= 0,
> > >  	.max_brightness	= 0x3ff,
> > 
> > I'd like to have this at least compile-tested, adding some CCs.
> 
> The change is visually ok, add my:
> 
> Acked-by: Marek Vasut <marek.vasut@gmail.com>

I now remember you already acked this change last year:
https://lkml.org/lkml/2010/12/4/41

Sorry that I forgot to resend the patch.

Best regards,
Nicolas Kaiser
