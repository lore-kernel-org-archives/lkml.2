Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab1IUGtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:49:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51109 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1IUGtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <1316587369.2824.4.camel@phoenix>
References: <1316587205.2824.1.camel@phoenix> <1316587369.2824.4.camel@phoenix>
From: Wan ZongShun <mcuos.com@gmail.com>
Date: Wed, 21 Sep 2011 14:49:21 +0800
Message-ID: <CAKT61h-wY4HaexDXf2tN+PVo1Bxhn75AoA4n1tg_mC3A3aAuJw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ASoC: Staticise nuc900_dma_getposition()
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/21 Axel Lin <axel.lin@gmail.com>:
> It is not used outside this driver so no need to make the symbol global.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/nuc900/nuc900-pcm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/soc/nuc900/nuc900-pcm.c b/sound/soc/nuc900/nuc900-pcm.c
> index e46d551..4e3626b 100644
> --- a/sound/soc/nuc900/nuc900-pcm.c
> +++ b/sound/soc/nuc900/nuc900-pcm.c
> @@ -227,7 +227,7 @@ static int nuc900_dma_trigger(struct snd_pcm_substream *substream, int cmd)
>        return ret;
>  }
>
> -int nuc900_dma_getposition(struct snd_pcm_substream *substream,
> +static int nuc900_dma_getposition(struct snd_pcm_substream *substream,
>                                        dma_addr_t *src, dma_addr_t *dst)
>  {
>        struct snd_pcm_runtime *runtime = substream->runtime;
> --
> 1.7.4.1
>

thanks!

Acked- by: Wan Zongshun <mcuos.com@gmail.com>

>
>
>



-- 
Wan ZongShun.
www.mcuos.com
