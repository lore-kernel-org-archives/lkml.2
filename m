Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1HaHiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 03:38:00 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:23873
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab1HaHh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 03:37:59 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371K542M1432Nzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH] ASoC: Remove unused variable 'card' in imx_pcm_fiq_new
Thread-Topic: [PATCH] ASoC: Remove unused variable 'card' in imx_pcm_fiq_new
Thread-Index: AQHMZ6HrfGJX4IpXrkKDmgt+kix9kpU2kdVQ
Date: Wed, 31 Aug 2011 07:37:50 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F77222BE87@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1314769825.28750.1.camel@phoenix>
In-Reply-To: <1314769825.28750.1.camel@phoenix>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7V7c8rt031510

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Axel Lin
> Sent: Wednesday, August 31, 2011 1:50 PM
> To: linux-kernel@vger.kernel.org
> Cc: Sascha Hauer; Liam Girdwood; Mark Brown; alsa-devel@alsa-project.org
> Subject: [PATCH] ASoC: Remove unused variable 'card' in imx_pcm_fiq_new
> 
> Fix below build warning:

It seems Fabio already sent this out a few days ago.
Please refer to:
http://comments.gmane.org/gmane.linux.alsa.devel/88686

>   CC      sound/soc/imx/imx-pcm-fiq.o
> sound/soc/imx/imx-pcm-fiq.c: In function 'imx_pcm_fiq_new':
> sound/soc/imx/imx-pcm-fiq.c:243: warning: unused variable 'card'
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/imx/imx-pcm-fiq.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/imx/imx-pcm-fiq.c b/sound/soc/imx/imx-pcm-fiq.c
> index 309c59e..7945625 100644
> --- a/sound/soc/imx/imx-pcm-fiq.c
> +++ b/sound/soc/imx/imx-pcm-fiq.c
> @@ -240,7 +240,6 @@ static int ssi_irq = 0;
> 
>  static int imx_pcm_fiq_new(struct snd_soc_pcm_runtime *rtd)  {
> -	struct snd_card *card = rtd->card->snd_card;
>  	struct snd_soc_dai *dai = rtd->cpu_dai;
>  	struct snd_pcm *pcm = rtd->pcm;
>  	int ret;
> --
> 1.7.4.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
