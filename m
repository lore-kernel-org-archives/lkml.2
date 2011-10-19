Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1JSIHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:07:03 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:57444 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab1JSIG7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:06:59 -0400
MIME-Version: 1.0
In-Reply-To: <1318992896.7128.1.camel@phoenix>
References: <1318992896.7128.1.camel@phoenix>
Date: Wed, 19 Oct 2011 09:06:57 +0100
Message-ID: <CABS+qY2n2xXVvK=CqOPXfH2YOYijPwSAc7tH=CYL1AJXGPxBNQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ASoC: sgtl5000: Fix define for SGTL5000_BIAS_R_MASK
From: "Girdwood, Liam" <lrg@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 October 2011 03:54, Axel Lin <axel.lin@gmail.com> wrote:
> According to the datasheet:
> CHIP_MIC_CTRL 0x002A
>
> BITS[9:8] BIAS_RESISTOR
>        0x0 = Powerd off
>        0x1 = 2.0 kohm
>        0x2 = 4.0 kohm
>        0x3 = 8.0 kohm
>
> Thus SGTL5000_BIAS_R_MASK should be defined as 0x0300 instead of 0x0200.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/sgtl5000.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
> index eec3ab3..8a9f435 100644
> --- a/sound/soc/codecs/sgtl5000.h
> +++ b/sound/soc/codecs/sgtl5000.h
> @@ -280,7 +280,7 @@
>  /*
>  * SGTL5000_CHIP_MIC_CTRL
>  */
> -#define SGTL5000_BIAS_R_MASK                   0x0200
> +#define SGTL5000_BIAS_R_MASK                   0x0300
>  #define SGTL5000_BIAS_R_SHIFT                  8
>  #define SGTL5000_BIAS_R_WIDTH                  2
>  #define SGTL5000_BIAS_R_off                    0x0
> --
> 1.7.5.4
>
>
>
>

Both

Acked-by: Liam Girdwood <lrg@ti.com>
