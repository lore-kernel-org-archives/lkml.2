Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab1J2T2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 15:28:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1J2T2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 15:28:07 -0400
Date: Sat, 29 Oct 2011 21:28:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [TRIVIAL] ARM: pxa: Fix typo
 'CONFIG_BACKLIGHT_PWM__MODULE'
In-Reply-To: <1318347115.5754.3.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1110292127320.3541@pobox.suse.cz>
References: <1318347115.5754.3.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested (I don't think I've got the hardware, nor have I got the
> toolchain at hand, etc.).
> 
>  arch/arm/mach-pxa/colibri-pxa270-income.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/colibri-pxa270-income.c b/arch/arm/mach-pxa/colibri-pxa270-income.c
> index 80538b8..248804b 100644
> --- a/arch/arm/mach-pxa/colibri-pxa270-income.c
> +++ b/arch/arm/mach-pxa/colibri-pxa270-income.c
> @@ -183,7 +183,7 @@ static inline void income_lcd_init(void) {}
>  /******************************************************************************
>   * Backlight
>   ******************************************************************************/
> -#if defined(CONFIG_BACKLIGHT_PWM) || defined(CONFIG_BACKLIGHT_PWM__MODULE)
> +#if defined(CONFIG_BACKLIGHT_PWM) || defined(CONFIG_BACKLIGHT_PWM_MODULE)
>  static struct platform_pwm_backlight_data income_backlight_data = {
>  	.pwm_id		= 0,
>  	.max_brightness	= 0x3ff,

I'd like to have this at least compile-tested, adding some CCs.

-- 
Jiri Kosina
SUSE Labs
