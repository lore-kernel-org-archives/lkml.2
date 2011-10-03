Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1JCFyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:54:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52309 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1JCFyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:54:03 -0400
Date: Mon, 3 Oct 2011 08:53:53 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Staticise ep93xx_ac97_dai
Message-ID: <20111003055353.GA2673@mwesterb-mobl.ger.corp.intel.com>
References: <1317612785.5065.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317612785.5065.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 11:33:05AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>

> ---
>  sound/soc/ep93xx/ep93xx-ac97.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/ep93xx/ep93xx-ac97.c b/sound/soc/ep93xx/ep93xx-ac97.c
> index c7417c7..3cd6158 100644
> --- a/sound/soc/ep93xx/ep93xx-ac97.c
> +++ b/sound/soc/ep93xx/ep93xx-ac97.c
> @@ -335,7 +335,7 @@ static struct snd_soc_dai_ops ep93xx_ac97_dai_ops = {
>  	.trigger	= ep93xx_ac97_trigger,
>  };
>  
> -struct snd_soc_dai_driver ep93xx_ac97_dai = {
> +static struct snd_soc_dai_driver ep93xx_ac97_dai = {
>  	.name		= "ep93xx-ac97",
>  	.id		= 0,
>  	.ac97_control	= 1,
> -- 
> 1.7.4.1
> 
> 
