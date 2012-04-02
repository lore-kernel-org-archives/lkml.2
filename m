Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2DBM6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:58:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60633 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2DBM6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 08:58:52 -0400
Message-ID: <4F79A27E.1010509@gmail.com>
Date: Mon, 02 Apr 2012 07:58:38 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Martin Jansa <martin.jansa@gmail.com>
CC: "moderated list:SOUND - SOC LAYER..." <alsa-devel@alsa-project.org>,
        Russell King <linux@arm.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        open list <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Eric Miao <eric.y.miao@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        "moderated list:PXA2xx/PXA3xx SUP..." 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: pxa: pxa2xx-i2s: add io.h for IOMEM macro
References: <1333355048-732-1-git-send-email-Martin.Jansa@gmail.com>
In-Reply-To: <1333355048-732-1-git-send-email-Martin.Jansa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 03:24 AM, Martin Jansa wrote:
> * fixes
>   sound/soc/pxa/pxa2xx-i2s.c:86:2: error: implicit declaration of function 'IOMEM' [-Werror=implicit-function-declaration]
>   sound/soc/pxa/pxa2xx-i2s.c:86:2: error: initializer element is not constant
>   after 23019a733bb83c8499f192fb428b7e6e81c95a34 removed IOMEM
>   definition from arch/arm/mach-pxa/include/mach/hardware.h
> 
> Signed-off-by: Martin Jansa <Martin.Jansa@gmail.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  sound/soc/pxa/pxa2xx-i2s.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/pxa/pxa2xx-i2s.c b/sound/soc/pxa/pxa2xx-i2s.c
> index 609abd5..d085837 100644
> --- a/sound/soc/pxa/pxa2xx-i2s.c
> +++ b/sound/soc/pxa/pxa2xx-i2s.c
> @@ -17,6 +17,7 @@
>  #include <linux/delay.h>
>  #include <linux/clk.h>
>  #include <linux/platform_device.h>
> +#include <linux/io.h>
>  #include <sound/core.h>
>  #include <sound/pcm.h>
>  #include <sound/initval.h>

