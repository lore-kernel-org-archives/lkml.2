Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1ISIjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:39:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:35837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab1ISIjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:39:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,404,1312182000"; 
   d="scan'208";a="53099571"
Subject: Re: [PATCH] ASoC: sn95031: Staticize sn95031_pcm_hw_params
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Harsha Priya <harshapriya@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1316421268.23109.1.camel@phoenix>
References: <1316421268.23109.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 14:05:20 +0530
Message-ID: <1316421320.26662.5.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 16:34 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/sn95031.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
> index b4f1cb4..29945b0 100644
> --- a/sound/soc/codecs/sn95031.c
> +++ b/sound/soc/codecs/sn95031.c
> @@ -658,7 +658,7 @@ static int sn95031_pcm_spkr_mute(struct snd_soc_dai *dai, int mute)
>  	return 0;
>  }
>  
> -int sn95031_pcm_hw_params(struct snd_pcm_substream *substream,
> +static int sn95031_pcm_hw_params(struct snd_pcm_substream *substream,
>  		struct snd_pcm_hw_params *params, struct snd_soc_dai *dai)
>  {
>  	unsigned int format, rate;

Acked-by: Vinod Koul <vinod.koul@linux.intel.com>

-- 
~Vinod

