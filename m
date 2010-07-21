Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab0GUMuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:50:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53200 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750993Ab0GUMub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:50:31 -0400
Date: Wed, 21 Jul 2010 13:50:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Geoffrey Wossum <gwossum@acm.org>,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 2/3] sound/soc/atmel: Remove dead
 CONFIG_AT32_ENHANCED_PORTMUX
Message-ID: <20100721125029.GB15462@rakim.wolfsonmicro.main>
References: <cover.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
 <d2382c03db1d5b41a857b67688bf32838993d137.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2382c03db1d5b41a857b67688bf32838993d137.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
X-Cookie: Who was that masked man?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 02:35:41PM +0200, Christian Dietrich wrote:
> CONFIG_AT32_ENCHANCED_PORTMUX doesn't exist in Kconfig or somewhere
> else, therefore removing all references for it from the source code.
> 
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

Please remember to CC maintainers on patches - I've added Geoffrey.

> ---
>  sound/soc/atmel/playpaq_wm8510.c |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/sound/soc/atmel/playpaq_wm8510.c b/sound/soc/atmel/playpaq_wm8510.c
> index 9df4c68..fbd17e9 100644
> --- a/sound/soc/atmel/playpaq_wm8510.c
> +++ b/sound/soc/atmel/playpaq_wm8510.c
> @@ -425,11 +425,6 @@ static int __init playpaq_asoc_init(void)
>  	clk_set_rate(CODEC_CLK, 12000000);
>  	clk_enable(CODEC_CLK);
>  
> -#if defined CONFIG_AT32_ENHANCED_PORTMUX
> -	at32_select_periph(MCLK_PIN, MCLK_PERIPH, 0);
> -#endif
> -
> -
>  	/*
>  	 * Create and register platform device
>  	 */
> @@ -496,10 +491,6 @@ static void __exit playpaq_asoc_exit(void)
>  		_pll0 = NULL;
>  	}
>  
> -#if defined CONFIG_AT32_ENHANCED_PORTMUX
> -	at32_free_pin(MCLK_PIN);
> -#endif
> -
>  	platform_device_unregister(playpaq_snd_device);
>  	playpaq_snd_device = NULL;
>  }
> -- 
> 1.7.0.4
> 
