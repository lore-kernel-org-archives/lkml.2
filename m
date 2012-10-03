Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2JCOvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:51:09 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:54818 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594Ab2JCOvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:51:07 -0400
Message-ID: <506C5124.3050200@ti.com>
Date: Wed, 03 Oct 2012 17:52:20 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: linux-kernel@vger.kernel.org, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3.7-rc1] omap zoom2.c: Fix compile error by including
 correct header files
References: <1349274686-45668-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1349274686-45668-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 05:31 PM, Tim Gardner wrote:
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: linux-omap@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  sound/soc/omap/zoom2.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/sound/soc/omap/zoom2.c b/sound/soc/omap/zoom2.c
> index 23de2b2..d0a8c92 100644
> --- a/sound/soc/omap/zoom2.c
> +++ b/sound/soc/omap/zoom2.c
> @@ -27,9 +27,10 @@
>  
>  #include <asm/mach-types.h>
>  #include <mach/hardware.h>
> -#include <mach/gpio.h>
> +#include <linux/gpio.h>
>  #include <mach/board-zoom.h>
>  #include <linux/platform_data/asoc-ti-mcbsp.h>
> +#include <linux/platform_data/gpio-omap.h>
>  
>  /* Register descriptions for twl4030 codec part */
>  #include <linux/mfd/twl4030-audio.h>
> 

I have the same patch stashed away for the same issue. Was waiting for rc1 to
send it.

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
