Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1JUQv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:51:26 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:41760 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891Ab1JUQvZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:51:25 -0400
MIME-Version: 1.0
In-Reply-To: <1319165047.4352.4.camel@phoenix>
References: <1319165047.4352.4.camel@phoenix>
Date: Fri, 21 Oct 2011 17:51:24 +0100
Message-ID: <CABS+qY198r1f2OtTPi7miXNUiL8-eO5Ve0f=5HqPD7dPXXtGVQ@mail.gmail.com>
Subject: Re: [PATCH] ASoC: wm8996: Fix wrong mask for setting WM8996_AIF_CLOCKING_2
From: "Girdwood, Liam" <lrg@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2011 03:44, Axel Lin <axel.lin@gmail.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/wm8996.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
> index 1d7b174..645c980 100644
> --- a/sound/soc/codecs/wm8996.c
> +++ b/sound/soc/codecs/wm8996.c
> @@ -1920,7 +1920,7 @@ static int wm8996_hw_params(struct snd_pcm_substream *substream,
>        snd_soc_update_bits(codec, lrclk_reg, WM8996_AIF1RX_RATE_MASK,
>                            lrclk);
>        snd_soc_update_bits(codec, WM8996_AIF_CLOCKING_2,
> -                           WM8996_DSP1_DIV_SHIFT << dsp_shift, dsp);
> +                           WM8996_DSP1_DIV_MASK << dsp_shift, dsp);
>
>        return 0;
>  }
> --
> 1.7.5.4
>

Acked-by: Liam Girdwood <lrg@ti.com>
