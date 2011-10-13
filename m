Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1JMIZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:25:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab1JMIZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:25:38 -0400
Date: Thu, 13 Oct 2011 10:25:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] [TRIVIAL] ARM: pxa: Fix typo
 'CONFIG_BACKLIGHT_PWM__MODULE'
In-Reply-To: <1318347115.5754.3.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1110131024160.14768@pobox.suse.cz>
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

Neither do I, so I'd like to get Ack from maintainer (added to CC) before 
I take this one, to make sure that it doesn't introduce some failure that 
has been hidden by this.

Marek? Thanks.

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
> -- 
> 1.7.4.4
> 

-- 
Jiri Kosina
SUSE Labs
