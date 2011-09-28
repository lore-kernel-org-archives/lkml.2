Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1I1HWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:22:33 -0400
Received: from smtp-out-142.synserver.de ([212.40.185.142]:1223 "HELO
	smtp-out-141.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753404Ab1I1HWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:22:31 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 14653
Message-ID: <4E82CB21.5060401@metafoo.de>
Date: Wed, 28 Sep 2011 09:22:09 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Fix setting adau1373_dai->master for SND_SOC_DAIFMT_CBS_CFS
References: <1317194096.2498.1.camel@phoenix>
In-Reply-To: <1317194096.2498.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 09:14 AM, Axel Lin wrote:
> In the case of SND_SOC_DAIFMT_CBS_CFS, adau1373_dai->master should be false.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks

> ---
>  sound/soc/codecs/adau1373.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/codecs/adau1373.c b/sound/soc/codecs/adau1373.c
> index 2aa40c3..1ccf8dd 100644
> --- a/sound/soc/codecs/adau1373.c
> +++ b/sound/soc/codecs/adau1373.c
> @@ -974,7 +974,7 @@ static int adau1373_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
>  		break;
>  	case SND_SOC_DAIFMT_CBS_CFS:
>  		ctrl = 0;
> -		adau1373_dai->master = true;
> +		adau1373_dai->master = false;
>  		break;
>  	default:
>  		return -EINVAL;

