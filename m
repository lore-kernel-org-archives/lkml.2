Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1JTJqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:46:30 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:43199 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932199Ab1JTJq3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:46:29 -0400
MIME-Version: 1.0
In-Reply-To: <1319079003.5380.1.camel@phoenix>
References: <1319079003.5380.1.camel@phoenix>
Date: Thu, 20 Oct 2011 10:46:28 +0100
Message-ID: <CABS+qY0z9E6_UsUcN34+Kjsid_RnpCufHxJxhez_f7-VX49BwA@mail.gmail.com>
Subject: Re: [PATCH] ASoC: Fix reg_word_size for ak4104
From: "Girdwood, Liam" <lrg@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 October 2011 03:50, Axel Lin <axel.lin@gmail.com> wrote:
> According to the register map in datasheet, the registers are 8 bit.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/ak4104.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/soc/codecs/ak4104.c b/sound/soc/codecs/ak4104.c
> index cbf0b6d..d3b29dc 100644
> --- a/sound/soc/codecs/ak4104.c
> +++ b/sound/soc/codecs/ak4104.c
> @@ -247,7 +247,7 @@ static struct snd_soc_codec_driver soc_codec_device_ak4104 = {
>        .probe =        ak4104_probe,
>        .remove =       ak4104_remove,
>        .reg_cache_size = AK4104_NUM_REGS,
> -       .reg_word_size = sizeof(u16),
> +       .reg_word_size = sizeof(u8),
>  };
>
>  static int ak4104_spi_probe(struct spi_device *spi)
> --
> 1.7.5.4
>

Acked-by: Liam Girdwood <lrg@ti.com>
