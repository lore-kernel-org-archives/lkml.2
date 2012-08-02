Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2HBMVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:21:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52800 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2HBMVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:21:08 -0400
Date: Thu, 2 Aug 2012 13:21:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
Message-ID: <20120802122101.GA22228@gmail.com>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
 <1343741493-17671-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1343741493-17671-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch withdrawn.

On Tue, Jul 31, 2012 at 02:31:23PM +0100, Lee Jones wrote:
> If a list of widgets is provided and one of them fails to be added as
> a control, the present semantics fail all subsequent widgets. A better
> solution would be to only fail that widget, but pursue in attempting
> to add the rest of the list.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  sound/soc/soc-dapm.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> index eded657..7d9c154 100644
> --- a/sound/soc/soc-dapm.c
> +++ b/sound/soc/soc-dapm.c
> @@ -3095,8 +3095,6 @@ int snd_soc_dapm_new_controls(struct snd_soc_dapm_context *dapm,
>  			dev_err(dapm->dev,
>  				"ASoC: Failed to create DAPM control %s\n",
>  				widget->name);
> -			ret = -ENOMEM;
> -			break;
>  		}
>  		widget++;
>  	}
> -- 
> 1.7.9.5
> 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
