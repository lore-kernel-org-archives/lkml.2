Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1J2Wfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 18:35:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56242 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab1J2Wfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 18:35:32 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] [TRIVIAL] ARM: pxa: Fix typo 'CONFIG_BACKLIGHT_PWM__MODULE'
Date: Sun, 30 Oct 2011 00:35:27 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
References: <1318347115.5754.3.camel@x61.thuisdomein> <alpine.LNX.2.00.1110292127320.3541@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1110292127320.3541@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110300035.27985.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 11 Oct 2011, Paul Bolle wrote:
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Untested (I don't think I've got the hardware, nor have I got the
> > toolchain at hand, etc.).
> > 
> >  arch/arm/mach-pxa/colibri-pxa270-income.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/mach-pxa/colibri-pxa270-income.c
> > b/arch/arm/mach-pxa/colibri-pxa270-income.c index 80538b8..248804b
> > 100644
> > --- a/arch/arm/mach-pxa/colibri-pxa270-income.c
> > +++ b/arch/arm/mach-pxa/colibri-pxa270-income.c
> > @@ -183,7 +183,7 @@ static inline void income_lcd_init(void) {}
> > 
> >  /***********************************************************************
> >  *******
> >  
> >   * Backlight
> >   ***********************************************************************
> >   *******/
> > 
> > -#if defined(CONFIG_BACKLIGHT_PWM) ||
> > defined(CONFIG_BACKLIGHT_PWM__MODULE) +#if defined(CONFIG_BACKLIGHT_PWM)
> > || defined(CONFIG_BACKLIGHT_PWM_MODULE)
> > 
> >  static struct platform_pwm_backlight_data income_backlight_data = {
> >  
> >  	.pwm_id		= 0,
> >  	.max_brightness	= 0x3ff,
> 
> I'd like to have this at least compile-tested, adding some CCs.

The change is visually ok, add my:

Acked-by: Marek Vasut <marek.vasut@gmail.com>
