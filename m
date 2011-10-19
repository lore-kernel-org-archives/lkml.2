Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab1JSQp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:45:27 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:59959 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574Ab1JSQpZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <1319036756.7741.1.camel@phoenix>
References: <1319036756.7741.1.camel@phoenix>
Date: Wed, 19 Oct 2011 17:45:24 +0100
Message-ID: <CABS+qY2oq4jv6dhBC+vvBLQ_BqBSPrCXqx5k2YOPUA_f7nW6Qw@mail.gmail.com>
Subject: Re: [PATCH] SoC: ak4641: Remove unused codec field from struct ak4641_priv
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

On 19 October 2011 16:05, Axel Lin <axel.lin@gmail.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/ak4641.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/sound/soc/codecs/ak4641.c b/sound/soc/codecs/ak4641.c
> index 7a64e58..f5125ae 100644
> --- a/sound/soc/codecs/ak4641.c
> +++ b/sound/soc/codecs/ak4641.c
> @@ -31,7 +31,6 @@
>
>  /* codec private data */
>  struct ak4641_priv {
> -       struct snd_soc_codec *codec;
>        unsigned int sysclk;
>        int deemph;
>        int playback_fs;
> --
> 1.7.5.4
>

Acked-by: Liam Girdwood <lrg@ti.com>
