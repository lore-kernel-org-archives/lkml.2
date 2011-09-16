Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1IPJ20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:28:26 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:47095 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495Ab1IPJ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:28:24 -0400
Subject: Re: [PATCH 1/2] ASoC: wm8995: Return -EINVAL if device ID mismatch
From: Liam Girdwood <lrg@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1316141193.21890.1.camel@phoenix>
References: <1316141193.21890.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 10:28:20 +0100
Message-ID: <1316165300.3229.8.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 10:46 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/wm8995.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
> index 5ad873f..05f7795 100644
> --- a/sound/soc/codecs/wm8995.c
> +++ b/sound/soc/codecs/wm8995.c
> @@ -1642,6 +1642,7 @@ static int wm8995_probe(struct snd_soc_codec *codec)
>  
>  	if (ret != 0x8995) {
>  		dev_err(codec->dev, "Invalid device ID: %#x\n", ret);
> +		ret = -EINVAL;
>  		goto err_reg_enable;
>  	}
>  

Both

Acked-by: Liam Girdwood <lrg@ti.com>

