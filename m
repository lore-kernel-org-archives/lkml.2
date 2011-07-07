Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1GGJUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:20:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44496 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1GGJUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:20:21 -0400
Message-ID: <4E157A4B.6060407@ti.com>
Date: Thu, 7 Jul 2011 10:20:11 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: pxa2xx-pcm: remove unused variable 'dai'
References: <1309958442.4613.1.camel@phoenix>
In-Reply-To: <1309958442.4613.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/11 14:20, Axel Lin wrote:
> Remove unused variable 'dai' to eliminate below warning.
> 
>   CC      sound/soc/pxa/pxa2xx-pcm.o
> sound/soc/pxa/pxa2xx-pcm.c: In function 'pxa2xx_soc_pcm_new':
> sound/soc/pxa/pxa2xx-pcm.c:91: warning: unused variable 'dai'
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/pxa/pxa2xx-pcm.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/pxa/pxa2xx-pcm.c b/sound/soc/pxa/pxa2xx-pcm.c
> index da28394..c430600 100644
> --- a/sound/soc/pxa/pxa2xx-pcm.c
> +++ b/sound/soc/pxa/pxa2xx-pcm.c
> @@ -88,7 +88,6 @@ static u64 pxa2xx_pcm_dmamask = DMA_BIT_MASK(32);
>  static int pxa2xx_soc_pcm_new(struct snd_soc_pcm_runtime *rtd)
>  {
>  	struct snd_card *card = rtd->card->snd_card;
> -	struct snd_soc_dai *dai = rtd->cpu_dai;
>  	struct snd_pcm *pcm = rtd->pcm;
>  	int ret = 0;
>  

Acked-by: Liam Girdwood <lrg@ti.com>
