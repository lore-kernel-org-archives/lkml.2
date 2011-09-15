Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370Ab1IOSF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:05:59 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:48223 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934277Ab1IOSF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:05:58 -0400
Subject: Re: [PATCH] ASoC: bf5xx-ad73311: Fix prototype for bf5xx_probe
From: Liam Girdwood <lrg@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Cliff Cai <Cliff.Cai@analog.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1316055896.3496.8.camel@phoenix>
References: <1316055896.3496.8.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 19:05:53 +0100
Message-ID: <1316109954.3333.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 11:04 +0800, Axel Lin wrote:
> Fix below build warning:
> sound/soc/blackfin/bf5xx-ad73311.c: warning: initialization from incompatible pointer type
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/blackfin/bf5xx-ad73311.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/blackfin/bf5xx-ad73311.c b/sound/soc/blackfin/bf5xx-ad73311.c
> index 732a247..b94eb7e 100644
> --- a/sound/soc/blackfin/bf5xx-ad73311.c
> +++ b/sound/soc/blackfin/bf5xx-ad73311.c
> @@ -128,7 +128,7 @@ static int snd_ad73311_configure(void)
>  	return 0;
>  }
>  
> -static int bf5xx_probe(struct platform_device *pdev)
> +static int bf5xx_probe(struct snd_soc_card *card)
>  {
>  	int err;
>  	if (gpio_request(GPIO_SE, "AD73311_SE")) {

Acked-by: Liam Girdwood <lrg@ti.com>

