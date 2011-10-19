Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1JSQs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:48:29 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:46405 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab1JSQs2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:48:28 -0400
MIME-Version: 1.0
In-Reply-To: <1319037894.7741.5.camel@phoenix>
References: <1319037894.7741.5.camel@phoenix>
Date: Wed, 19 Oct 2011 17:48:27 +0100
Message-ID: <CABS+qY1o93bsBVtyU+1fZu1xp0HAWZ7i81X_AOvZk2hZUdReVg@mail.gmail.com>
Subject: Re: [PATCH] ASoC: ak4641: Use SND_SOC_DAPM_DAC for Voice Playback
 stream widget
From: "Girdwood, Liam" <lrg@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Dmitry Artamonow <mad_soft@inbox.ru>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 October 2011 16:24, Axel Lin <axel.lin@gmail.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/ak4641.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/soc/codecs/ak4641.c b/sound/soc/codecs/ak4641.c
> index f5125ae..7783858 100644
> --- a/sound/soc/codecs/ak4641.c
> +++ b/sound/soc/codecs/ak4641.c
> @@ -225,7 +225,7 @@ static const struct snd_soc_dapm_widget ak4641_dapm_widgets[] = {
>        SND_SOC_DAPM_PGA("Mono Out 2", AK4641_PM2, 3, 0, NULL, 0),
>
>        SND_SOC_DAPM_ADC("Voice ADC", "Voice Capture", AK4641_BTIF, 0, 0),
> -       SND_SOC_DAPM_ADC("Voice DAC", "Voice Playback", AK4641_BTIF, 1, 0),
> +       SND_SOC_DAPM_DAC("Voice DAC", "Voice Playback", AK4641_BTIF, 1, 0),
>
>        SND_SOC_DAPM_MICBIAS("Mic Int Bias", AK4641_MIC, 3, 0),
>        SND_SOC_DAPM_MICBIAS("Mic Ext Bias", AK4641_MIC, 4, 0),
> --
> 1.7.5.4
>

Ah, good catch. Surprised the author did not notice that :)

Acked-by: Liam Girdwood <lrg@ti.com>


>
>
