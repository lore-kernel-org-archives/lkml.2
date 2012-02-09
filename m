Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2BIHTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:19:19 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:37624 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab2BIHTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:19:18 -0500
Message-ID: <4F337379.9060006@ti.com>
Date: Thu, 09 Feb 2012 09:19:21 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120208 Thunderbird/10.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: Re: [PATCH] [trivial] twl4030: Fix typo in twl4030.c
References: <1328702014-1956-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1328702014-1956-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/08/2012 01:53 PM, Masanari Iida wrote:
> Correct spelling "memroy" to "memory" in
> sound/soc/codecs/twl4030.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  sound/soc/codecs/twl4030.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
> index 3039ba2..d7eee0d 100644
> --- a/sound/soc/codecs/twl4030.c
> +++ b/sound/soc/codecs/twl4030.c
> @@ -2221,7 +2221,7 @@ static int twl4030_soc_probe(struct snd_soc_codec *codec)
>  
>  	twl4030 = kzalloc(sizeof(struct twl4030_priv), GFP_KERNEL);
>  	if (twl4030 == NULL) {
> -		printk("Can not allocate memroy\n");
> +		printk("Can not allocate memory\n");
>  		return -ENOMEM;
>  	}
>  	snd_soc_codec_set_drvdata(codec, twl4030);

Could you please resend the patch with the ASoC maintainers on CC (Liam,
Mark), and the alsa-devel list.
Thank you.

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
