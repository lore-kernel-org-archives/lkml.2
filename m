Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1JXMGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:06:36 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:57360 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932075Ab1JXMGf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <1319427235.5773.4.camel@phoenix>
References: <1319427161.5773.3.camel@phoenix>
	<1319427235.5773.4.camel@phoenix>
Date: Mon, 24 Oct 2011 13:06:34 +0100
Message-ID: <CABS+qY0a-w5igUod7eMeYqt9GZsj-aFS3Oa-VUPUHE-LTSVG8g@mail.gmail.com>
Subject: Re: [PATCH 2/3] ASoC: wm8940: Fix a typo for the mask of setting WM8940_BCLKDIV
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

On 24 October 2011 04:33, Axel Lin <axel.lin@gmail.com> wrote:
> The registers are 16 bits, thus remove an extra F for the mask.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/wm8940.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
> index 3cc3bce..fec3892 100644
> --- a/sound/soc/codecs/wm8940.c
> +++ b/sound/soc/codecs/wm8940.c
> @@ -619,7 +619,7 @@ static int wm8940_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
>
>        switch (div_id) {
>        case WM8940_BCLKDIV:
> -               reg = snd_soc_read(codec, WM8940_CLOCK) & 0xFFEF3;
> +               reg = snd_soc_read(codec, WM8940_CLOCK) & 0xFEF3;
>                ret = snd_soc_write(codec, WM8940_CLOCK, reg | (div << 2));
>                break;
>        case WM8940_MCLKDIV:
> --

Acked-by: Liam Girdwood <lrg@ti.com>
