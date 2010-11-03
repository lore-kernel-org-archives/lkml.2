Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab0KCS0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:26:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40867 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab0KCS0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:26:20 -0400
Subject: Re: [alsa-devel] [PATCH] ASoC: Remove register write trace from
 WM8994
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288806654-29936-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1288806654-29936-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 18:26:14 +0000
Message-ID: <1288808774.3277.109.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 13:50 -0400, Mark Brown wrote:
> We now have trace in the ASoC core so we don't need to our own trace in
> the driver.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  sound/soc/codecs/wm8994.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
> index 3f70dee..d81cac5 100644
> --- a/sound/soc/codecs/wm8994.c
> +++ b/sound/soc/codecs/wm8994.c
> @@ -1730,8 +1730,6 @@ static int wm8994_write(struct snd_soc_codec *codec, unsigned int reg,
>  	if (!wm8994_volatile(reg))
>  		wm8994->reg_cache[reg] = value;
>  
> -	dev_dbg(codec->dev, "0x%x = 0x%x\n", reg, value);
> -
>  	return wm8994_reg_write(codec->control_data, reg, value);
>  }
>  

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>


-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

