Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1JTQwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:52:22 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:37996 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495Ab1JTQwV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:52:21 -0400
MIME-Version: 1.0
In-Reply-To: <1319084004.12737.0.camel@phoenix>
References: <1319084004.12737.0.camel@phoenix>
Date: Thu, 20 Oct 2011 17:52:20 +0100
Message-ID: <CABS+qY0_f+nqjynSzomkxBvEX=-GBoOL2WDOnsHedRMj72nfRQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ASoC: wm8994: Use SND_SOC_DAPM_AIF_OUT for AIF3 Capture
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

On 20 October 2011 05:13, Axel Lin <axel.lin@gmail.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/wm8994.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
> index 68e769e..03621e2 100644
> --- a/sound/soc/codecs/wm8994.c
> +++ b/sound/soc/codecs/wm8994.c
> @@ -1419,7 +1419,7 @@ SND_SOC_DAPM_MUX("AIF2DAC Mux", SND_SOC_NOPM, 0, 0, &aif2dac_mux),
>  SND_SOC_DAPM_MUX("AIF2ADC Mux", SND_SOC_NOPM, 0, 0, &aif2adc_mux),
>
>  SND_SOC_DAPM_AIF_IN("AIF3DACDAT", "AIF3 Playback", 0, SND_SOC_NOPM, 0, 0),
> -SND_SOC_DAPM_AIF_IN("AIF3ADCDAT", "AIF3 Capture", 0, SND_SOC_NOPM, 0, 0),
> +SND_SOC_DAPM_AIF_OUT("AIF3ADCDAT", "AIF3 Capture", 0, SND_SOC_NOPM, 0, 0),
>
>  SND_SOC_DAPM_SUPPLY("TOCLK", WM8994_CLOCKING_1, 4, 0, NULL, 0),
>
> --
> 1.7.5.4
>
>
>
>

Both

Acked-by: Liam Girdwood <lrg@ti.com>
